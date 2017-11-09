//
//  ViewController.swift
//  AddEmAll2
//
//  Created by Gerardo Mares on 10/29/17.
//  Copyright © 2017 GerardoMares. All rights reserved.
//

import UIKit
import Alamofire
import TwitterKit

class ViewController: UIViewController {
    
    let defaultValues = UserDefaults.standard
    
    let URL_USER_REGISTER = "http://ec2-18-216-72-146.us-east-2.compute.amazonaws.com/v1/register.php"
    let URL_USER_LOGIN = "http://ec2-18-216-72-146.us-east-2.compute.amazonaws.com/v1/login.php"
    
//    let URL_USER_REGISTER = "http://172.25.253.52:8888/v1/register.php"
//    let URL_USER_LOGIN = "http://172.25.253.52:8888/v1/login.php"


    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var labelMessage: UILabel!
    
    @IBAction func loginButton(_ sender: Any) {
            
            //getting the username and password
            let parameters: Parameters=[
                "email": emailField.text!,
                "password": passwordField.text!
            ]
            
            //making a post request
            Alamofire.request(URL_USER_LOGIN, method: .post, parameters: parameters).responseJSON
                {
                    response in
                    //printing response
                    print(response)
                    
                    //getting the json value from the server
                    if let result = response.result.value {
                        let jsonData = result as! NSDictionary
                        
                        //if there is no error
                        if(!(jsonData.value(forKey: "error") as! Bool)){
                            
                            //getting the user from response
                            let user = jsonData.value(forKey: "user") as! NSDictionary
                            
                            //getting user values
                            let userName = user.value(forKey: "name") as! String
                            let userEmail = user.value(forKey: "email") as! String
                            //saving user values to defaults
                            
                            self.defaultValues.set(userName, forKey: "username")
                            self.defaultValues.set(userEmail, forKey: "useremail")
                            
                            //switching the screen
                            let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                            self.navigationController?.pushViewController(profileViewController, animated: true)
                            
                            self.dismiss(animated: false, completion: nil)
                        }else{
                            //error message in case of invalid credential
                            self.labelMessage.text = "Invalid username or password"
                        }
                    }
            }
        }
    
    @IBAction func registerButton(_ sender: Any) {
        
        //creating parameters for the post request
        let parameters: Parameters=[
            "name": nameField.text!,
            "email": emailField.text!,
            "password": passwordField.text!
        ]
        
        //Sending http post request
        Alamofire.request(URL_USER_REGISTER, method: .post, parameters: parameters).responseJSON
            {
                response in
                //printing response
                print(response)
                
                //getting the json value from the server
                if let result = response.result.value {
                    
                    //converting it as NSDictionary
                    let jsonData = result as! NSDictionary
                    
                    //displaying the message in label
                    self.labelMessage.text = jsonData.value(forKey: "message") as! String?
                }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //if user is already logged in switching to profile screen
        if defaultValues.string(forKey: "email") != nil{
            let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewcontroller") as! ProfileViewController
            self.navigationController?.pushViewController(profileViewController, animated: true)
            
        }
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

