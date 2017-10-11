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

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
            }
            
        })
        
    }
    
}

