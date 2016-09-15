//
//  ViewController.swift
//  instagram
//
//  Created by Tan Yee Gene on 08/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FBSDKLoginKit
import GoogleSignIn

class SignUpViewController: UIViewController,  GIDSignInUIDelegate, FBSDKLoginButtonDelegate  {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet var fbLoginButton: FBSDKLoginButton!
    let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        GIDSignIn.sharedInstance().uiDelegate = self
        self.fbLoginButton.delegate = self
        super.viewDidLoad()
    }
    
    @IBAction func tapAction(sender: UITapGestureRecognizer) {
        self.usernameTextField.resignFirstResponder()
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
    
    @IBAction func signUpButton(sender: UIButton) {
        
        guard
            let username = usernameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text else { return
        }
        FIRAuth.auth()?.createUserWithEmail(email, password: password) { (user, error) in
            if error != nil{
                print(error?.localizedDescription)
                return
            }else {
                let uid = user!.uid
                NSUserDefaults.standardUserDefaults().setObject(uid, forKey: "userUID")
                
                let firebaseRef = FIRDatabase.database().reference()
                let username = ["username" : username]
                firebaseRef.child("Usernames").child(uid).setValue(username)
                let storyBoard = UIStoryboard(name:"HomeStoryboard", bundle:NSBundle.mainBundle())
                
                let tabBarController = storyBoard.instantiateViewControllerWithIdentifier("FeedTabBarController")
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                appDelegate.window?.rootViewController=tabBarController
            }
        }
    }
    
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        //        if result.isCancelled{ return }
        
        let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
        FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
            if let user = user {
                //successfully signed up
                print("inside")
                
                NSUserDefaults.standardUserDefaults().setObject(user.uid, forKey: "userUID")
                self.performSegueWithIdentifier("HomeSegue", sender: nil)
                
                let firebaseRef = FIRDatabase.database().reference()
                let currentUserRef = firebaseRef.child("Usernames").child(user.uid)
                let userDict = ["username": user.displayName!]
                currentUserRef.setValue(userDict)
            } else{
                //sign up failed
                print("outside")
                let alert = UIAlertController(title: "Sign up Failed", message: error?.localizedDescription, preferredStyle: .Alert)
                let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
                
                alert.addAction(dismissAction)
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        try! FIRAuth.auth()!.signOut()
    }
    
}


