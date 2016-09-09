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
    
//    var userIdentity : [user]()
//    var userPicture : [user]()
    let section = ["name 1", "name 2", "name 3"]
    let rows = ["picture 1", "picture 2", "picture3"]
//
//    
    
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
    
    ////TABLE VIEW METHODS
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.section.count
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let header = NSBundle.mainBundle().loadNibNamed("headerVIew", owner: 0, options: nil)[0] as? UIView
        
        print(header)
        return header
        
    }

    
//    optional func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
//        if section == 1 {
//            
//        }
//    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        
        if indexPath.row == 0{
            let pictureCell = self.tableView.dequeueReusableCellWithIdentifier("pictureCell", forIndexPath: indexPath) as! PictureCellTableViewCell
            pictureCell.pictureImageView.image = UIImage(named:"camera") ?? UIImage(named: "heart")
            return pictureCell
        
        } else{
            let cell = self.tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! CommentTableViewCell
            
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if (section == 0) {
//            return 2 // At the moment I have hard coded it will change it to array.count
//        } else {
//            return 2
//        }
        return 2
        }
}

