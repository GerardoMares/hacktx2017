//
//  ViewController.swift
//  AddEmAll
//
//  Created by Gerardo Mares on 10/28/17.
//  Copyright © 2017 GerardoMares. All rights reserved.
//

import UIKit
import TwitterKit
import Foundation

class ViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBAction func login(_ sender: UIButton) {
        
        if(email.hasText && password.hasText) {
            //loginUser(email: email.text, password: password.text)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var twitter = "BigPackageDylan"
        let email = "gerardo@test.com"
        let name = "MyName"
        let password = "password"

        var loggedin = false


        let logInButton = TWTRLogInButton(logInCompletion: { session, error in
            if (session != nil) {

                self.addAccount(email: email, account: "Twitter", value: (session?.userName)!)

            } else {
                print("error: \(String(describing: error?.localizedDescription))");
            }
        })


            logInButton.center = self.view.center
            self.view.addSubview(logInButton)

        

    
    }
    
    func loginUser(email: String, password :String) {
        
        
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
                    print("Error: ")
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    print("json: \(json)")
                    self.label.text = "Followed Dylan";
                } catch let jsonError as NSError {
                    print("json error: \(jsonError.localizedDescription)")
                }
            }
        }
        
    }
    
    func addUser(name : String, email : String, password : String) {
        let urlPath = "http://172.25.253.52:8888/add/User.php?email=" + email + "&name=" + name + "&password=" + password;
        
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print("Failed to add User")
            } else {
                
                print("Success Adding User")
            }
            
        }
        
        task.resume()
    }
    
    
    func accountExists(email : String) -> Bool{
        
        var result = false;
        
        let urlPath = "http://172.25.253.52:8888/add/UserExists.php?email=" + email
        
//        let url: URL = URL(string: urlPath)!
//        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        
        let url = URL(string: "http://172.25.253.52:8888/add/UserExists.php?email=" + email)
        
        if let usableUrl = url {
            let request = URLRequest(url: usableUrl)
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if error != nil {
                    print("Failed to check")
                } else {
                    do {
                        if let data = data {
                            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
    
    
                            if(json!["status"] as! Bool) {
                                result = true;
                            }
    
    
                        }
                    } catch {
                        print("Error deserializing JSON: \(error)")
                    }
    
    
                }
            })
            task.resume()
        }
        
        
        return result;
    }
    
    
    func addAccount(email: String, account : String, value : String) {
        let urlPath = "http://172.25.253.52:8888/add/Account.php?email=" + email + "&account=" + account + "&value=" + value;
        
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print("Failed to add User")
            } else {
                
                print("Success Adding User")
            }
            
        }
        
        task.resume()
    }
    
    
    func getDataFor(id: String) {
        let urlPath = "http://172.25.253.52:8888/get/Data.php?email="
        
        let url: URL = URL(string: urlPath + id)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print("Failed to download data")
            } else {
                
                do {
                    if let data = data {
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    
                        print(json)
                    
                    
                    }
                } catch {
                    print("Error deserializing JSON: \(error)")
                }
            }
            
        }
        
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

