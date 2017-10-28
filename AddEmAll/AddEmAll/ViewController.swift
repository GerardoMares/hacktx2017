//
//  ViewController.swift
//  AddEmAll
//
//  Created by Gerardo Mares on 10/28/17.
//  Copyright © 2017 GerardoMares. All rights reserved.
//

import UIKit
import TwitterKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.label.text = "Not logged in";
    
        let logInButton = TWTRLogInButton(logInCompletion: { session, error in
            if (session != nil) {
                self.label.text = "Logged in as \(session!.userName)";
                self.follow();
                
            } else {
                print("error: \(String(describing: error?.localizedDescription))");
            }
        })
        logInButton.center = self.view.center
        self.view.addSubview(logInButton)
        
    
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
                    print("Error: \(connectionError)")
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

