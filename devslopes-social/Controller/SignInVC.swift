//
//  ViewController.swift
//  devslopes-social
//
//  Created by Seth Skocelas on 10/9/17.
//  Copyright © 2017 Seth Skocelas. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var pwdField: FancyField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            
            performSegue(withIdentifier: "goToFeed", sender: nil)
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookBtnTap(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                
                print("READ THIS: Unable to authenticate with Facebook")
                
            } else if result?.isCancelled == true {
                
                print("READ THIS - User cancelled")
                
            } else {
                
                print("READ THIS - Successful Auth")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
        
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            
            if error != nil {
                
                print("READ THIS: Unable to auth with Firebase")
                
            } else {
                
                print("READ THIS: Successfully auth with Firebase ")
                
                if let user = user {
                    self.completeSignIn(id: user.uid)
                }
            }
            
        })
        
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        
        if let email = emailField.text, let pwd = pwdField.text {
            
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
            
                if error == nil {
                    
                    print("READ THIS: Email User auth with Firebase")
                    
                    if let user = user {
                        self.completeSignIn(id: user.uid)
                    }
                    
                } else {
                    
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        
                        if error != nil {
                            
                            print("READ THIS: Unable to create account \(error!) ")
                            
                        } else {
                            
                            print("READ THIS: Account created successfully")
                            
                            if let user = user {
                                self.completeSignIn(id: user.uid)
                            }
                            
                        }
                        
                    })
                    
                }
            
            })
            
        }
        
    }
    
    func completeSignIn(id: String) {
        
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("READ THIS: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
        
    }
    
    
}

