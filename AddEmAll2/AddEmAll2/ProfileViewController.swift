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
    
    let URL_ADD_Account = "http://172.25.253.52:8888/v1/addAccount.php"
    
    //label again don't copy instead connect
    @IBOutlet weak var labelUserName: UILabel!
    
    //button
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
        
        //hiding back button
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        //getting user data from defaults
        let defaultValues = UserDefaults.standard
        if let name = defaultValues.string(forKey: "username"){
            //setting the name to label 
            labelUserName.text = name
            
        }else{
            //send back to login view controller
        }
        
        
        
        let email = defaultValues.string(forKey: "useremail")
        
        labelUserName.text = email
        
        if(email != nil) {
            let logInButton = TWTRLogInButton(logInCompletion: { session, error in
                
                if (session != nil) {

                        print("EMAIL")
                        print(email)
//                    self.addAccount(email: email!, account: "Twitter", value: (session?.userName)!)


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
        
        //creating parameters for the post request
        let parameters: Parameters=[
            "email": email,
            "account": account,
            "value" : value
        ]
        
        //Sending http post request
        Alamofire.request(URL_ADD_Account, method: .post, parameters: parameters).responseJSON
            {
                response in
                //printing response
                print(response)
                
                //getting the json value from the server
                if let result = response.result.value {
                    
                    //converting it as NSDictionary
                    let jsonData = result as! NSDictionary
                    
                    //displaying the message in label
                    self.labelUserName.text = jsonData.value(forKey: "message") as! String?
                }
        }
    }
    
    
}
