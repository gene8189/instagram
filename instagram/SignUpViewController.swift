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
     let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        GIDSignIn.sharedInstance().uiDelegate = self
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clearColor()
        gradientLayer.frame = self.view.bounds
        
        let color1 = UIColor.whiteColor().CGColor as CGColorRef
        let color2 = UIColor(red: 0.1, green: 0, blue: 0.5, alpha: 0.7).CGColor as CGColorRef
        let color3 = UIColor(red: 0.1, green: 0.1, blue: 0.5, alpha: 0.3).CGColor as CGColorRef
        let color4 = UIColor(white: 0.5, alpha: 0.4)
        gradientLayer.colors = [color1, color2, color3, color4]
        
        gradientLayer.locations = [0.0, 0.15, 0.55, 0.7]
        self.view.layer.addSublayer(gradientLayer)

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
            let password = passwordTextField.text  else{
                
                return
        }
        
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: {(user, error) in
            if let user = user{
                NSUserDefaults.standardUserDefaults().setObject(user.uid, forKey: "userUID")
                
                //sign up succes
                //(segue to next view)
                
                let firebaseRef = FIRDatabase.database().reference()
                let currentUserRef = firebaseRef.child("users").child(user.uid)
                let userDict = ["email":email, "username":username]
                currentUserRef.setValue(userDict)
            }else{
                //failed
                let alert = UIAlertController(title: "Sign Up Fail", message: error?.localizedDescription, preferredStyle: . Alert )
                let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
                alert.addAction(dismissAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })

    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
        let appDelegateTemp = UIApplication.sharedApplication().delegate!  //need to get instance of AppDelegate
        FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
            if let user=user {
                NSUserDefaults.standardUserDefaults().setObject(user.uid, forKey: "userUID")
                self.performSegueWithIdentifier("HomeSegue", sender: nil)
                let storyBoard = UIStoryboard(name:"HomeStoryboard", bundle:NSBundle.mainBundle())
                
                //load viewcontroller with the storyboardID of HomeTabBarController
                let tabBarController = storyBoard.instantiateViewControllerWithIdentifier("FeedTabBarController")
                
                appDelegateTemp.window?!.rootViewController=tabBarController
            }
        }
    }
    
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        try! FIRAuth.auth()!.signOut()
    }
    
}

    


