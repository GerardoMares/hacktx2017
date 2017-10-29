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

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        self.label.text = "Not logged in";
//
//        let logInButton = TWTRLogInButton(logInCompletion: { session, error in
//            if (session != nil) {
//                self.label.text = "Logged in as \(session!.userName)";
//                self.follow();
//
//            } else {
//                print("error: \(String(describing: error?.localizedDescription))");
//            }
//        })
//        logInButton.center = self.view.center
//        self.view.addSubview(logInButton)

        downloadItems(id:"1")
        downloadItems(id:"2")
    
    }
    
    func follow() {
        let store = Twitter.sharedInstance().sessionStore
        
        if let userid = store.session()?.userID {
            let client = TWTRAPIClient(userID: userid)
        
            let followEndpoint = "https://api.twitter.com/1.1/friendships/create.json"
            let params = ["screen_name" : "BigPackageDylan", "follow" : "true"]
            var clientError : NSError?
            
            let request = client.urlRequest(withMethod: "POST", url: followEndpoint, parameters: params, error: &clientError)
            
            client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                if connectionError != nil {
//                    print("Error: \(connectionError)")
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
    
    
    func downloadItems(id: String) {
        let urlPath = "http://172.25.253.52:8888/add/add.php?id="
        
        let url: URL = URL(string: urlPath + id)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print("Failed to download data")
            } else {
                
                do {
                    if let data = data {
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
//
//                        if let userid = json!["Id"] as! String
//                        let name = json!["Name"] as! String
//                        let tw = json!["Twitter"] as! String
//                        let fb = json!["Facebook"] as! String
//                        let sc = json!["Snapchat"] as! String
//                        let ig = json!["Instagram"] as! String
                    
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

