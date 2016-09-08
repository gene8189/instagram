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

class LogInViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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



