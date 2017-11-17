//
//  ProfileViewController.swift
//  AddEmAll2
//
//  Created by Gerardo Mares on 10/29/17.
//  Copyright © 2017 GerardoMares. All rights reserved.
//

import Foundation
import UIKit
import TwitterKit
import Alamofire

class ProfileViewController: UIViewController {
    let defaultValues = UserDefaults.standard
    
    @IBOutlet weak var imageView: UIImageView!

//    let URL_ADD_Account = "http://ec2-18-216-72-146.us-east-2.compute.amazonaws.com/v1/addAccount.php"
//    let URL_GET_Twitter = "http://ec2-18-216-72-146.us-east-2.compute.amazonaws.com/v1/getAccount.php"
    
    let URL_ADD_Account = "http://169.254.237.204:8888/v1/addAccount.php"
    let URL_GET_Twitter = "http://169.254.237.204:8888/v1/getAccount.php"
    

    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var newFriend: UITextField!
    
    
    @IBAction func submitNewFriend(_ sender: UIButton) {
        if (newFriend.hasText) {
            getTwitter(email: newFriend.text!)
        }
    }
    
    @IBAction func buttonLogout(_ sender: UIButton) {
        
        //removing values from default
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        
        //switching to login screen
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(loginViewController, animated: true)
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        let defaultValues = UserDefaults.standard
        if let name = defaultValues.string(forKey: "username"){ labelUserName.text = name }
        
        let email = defaultValues.string(forKey: "useremail")
        let image = generateQRCode(from: email!)
        
        imageView.image = image
        
        if(email != nil) {
            let logInButton = TWTRLogInButton(logInCompletion: { session, error in
                
                if (session != nil) {
                    self.addAccount(email: email!, account: "Twitter", value: (session?.userName)!)

                } else {
                    print("NIL SESSION")
                }
            })

            logInButton.center = self.view.center
            self.view.addSubview(logInButton)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addAccount(email: String, account : String, value : String) {
        
        let parameters: Parameters=["email": email, "account": account, "value" : value]
        
        Alamofire.request(URL_ADD_Account, method: .post, parameters: parameters).responseJSON {
            response in
            
            if let result = response.result.value {
                
                let jsonData = result as! NSDictionary
                self.labelUserName.text = jsonData.value(forKey: "message") as! String?
            }
        }
    }
    
    func getTwitter(email: String) {
        
        let parameters: Parameters=[ "email": email, "account": "Twitter"]
        
        Alamofire.request(URL_GET_Twitter, method: .post, parameters: parameters).responseJSON {
            response in
            
            if let result = response.result.value {
    
                let jsonData = result as! NSDictionary
                let twitterName = jsonData.value(forKey: "account") as! String?
                self.follow(user: twitterName!);
            }
        }
    }
    
    func follow(user: String) {
        let store = Twitter.sharedInstance().sessionStore
        
        if let userid = store.session()?.userID {
            
            let client = TWTRAPIClient(userID: userid)
            
            let followEndpoint = "https://api.twitter.com/1.1/friendships/create.json"
            let params = ["screen_name" : user, "follow" : "true"]
            var clientError : NSError?
            
            let request = client.urlRequest(withMethod: "POST", url: followEndpoint, parameters: params, error: &clientError)
            
            client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                if connectionError != nil {
                    print("Error: connection")
                }
                
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    
                    print("json: \(json)")
                    self.labelUserName.text = "Followed User";
                    
                } catch let jsonError as NSError {
                    print("json error: \(jsonError.localizedDescription)")
                }
            }
        }
        
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
    
    @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
