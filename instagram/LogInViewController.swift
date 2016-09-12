//
//  LogInViewController.swift
//  instagram
//
//  Created by Keith Piong on 08/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import GoogleSignIn

class LogInViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tapAction(sender: AnyObject) {
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
    
    
    @IBAction func onLoginButtonPressed(sender: AnyObject) {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
            else {return}
        
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion:  { (user, error) in
            if error != nil {
                print(error?.localizedDescription)
                return
                
            }else {
                let uid = user?.uid
                FIRDatabase.database().reference().child("usernames").child(uid!).observeEventType(.Value, withBlock: { (snapshot) in
                    guard let username = snapshot.value as? String else {
                        print("no user found")
                        return
                    }
                    FIRDatabase.database().reference().child("profiles").child(username).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                        guard let profile = snapshot.value as? [String : AnyObject] else {
                        print("no profile found for user")
                            return
                        }
                        Profile.currentUser = Profile.initWithUsername(username, profileDict: profile)
                        let storyBoard = UIStoryboard(name:"HomeStoryboard", bundle:NSBundle.mainBundle())

                        let tabBarController = storyBoard.instantiateViewControllerWithIdentifier("FeedTabBarController")
                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

                        appDelegate.window?.rootViewController=tabBarController
                    })
                })
            }
            
        })
    }
    
    @IBAction func backToSignUp(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: {});
        
    }
}



