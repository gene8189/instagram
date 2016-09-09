//
//  FeedViewController.swift
//  instagram
//
//  Created by Keith Piong on 08/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    func optionsButtonDidSelect() {
        
        let alert = UIAlertController(title: "Sign up Failed", message:"", preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
        
        alert.addAction(dismissAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func onLogoutButtonPressed(sender: AnyObject) {try! FIRAuth.auth()!.signOut()
        NSUserDefaults.standardUserDefaults().removeObjectForKey("userUID")
        
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let viewController = storyboard.instantiateViewControllerWithIdentifier("SignUpViewController")
        self.presentViewController(viewController, animated: true, completion: nil)
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("userCell", forIndexPath: indexPath) as! UserTableViewCell
        cell.usernameLabel.text = "user"
        cell.profileImageView.image = UIImage(named:"profile") ?? UIImage(named: "heart")
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    //    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        <#code#>
    //    }
}

