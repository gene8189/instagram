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
            if let user = user {
                NSUserDefaults.standardUserDefaults().setObject(user.uid, forKey: "userUID")
                self.performSegueWithIdentifier("HomeSegue", sender: nil)
                
                               
            
            }else{
                //failed sign in
                let alert = UIAlertController (title: "Sign In Failed", message: error?.localizedDescription, preferredStyle: .Alert)
                let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
                alert.addAction(dismissAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
    }

    @IBAction func backToSignUp(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: {});
        
    }
   }



