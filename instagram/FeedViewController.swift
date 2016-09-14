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

struct post {
    var username: String!
    var caption: String!
    var image: String!

    
}


class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HeaderViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    var sectionUser = [post]()
    
//    let section = [Post]()
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        DataService.postRef.queryOrderedByKey().observeEventType(.ChildAdded, withBlock: {(snapshot) in
            
            let usernameUser = snapshot.value!["username"] as! String
            let captionUser = snapshot.value!["caption"] as! String
            
            let imageUserString = snapshot.value!["image"] as! String
//            let decodedData = NSData(base64EncodedString: imageUserString, options: NSDataBase64DecodingOptions(rawValue: 0))
//            let imageUser = UIImage(data: decodedData!)
            self.sectionUser.insert(post(username: usernameUser, caption: captionUser, image: imageUserString), atIndex: 0)
            print(self.sectionUser)
            
            self.tableView.reloadData()
        })
    }
    

    
    @IBAction func onLogoutButtonPressed(sender: AnyObject) {try! FIRAuth.auth()!.signOut()
        NSUserDefaults.standardUserDefaults().removeObjectForKey("userUID")
        
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let viewController = storyboard.instantiateViewControllerWithIdentifier("SignUpViewController")
        self.presentViewController(viewController, animated: true, completion: nil)
        
    }
    
    ////TABLE VIEW METHODS
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sectionUser.count
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let header = NSBundle.mainBundle().loadNibNamed("headerVIew", owner: 0, options: nil)[0] as? HeaderView
        header?.delegate = self
        header?.usernameLabel.setTitle("\(self.sectionUser[section].username)", forState: .Normal)
        return header
        
    }
    
    func profileButtonTapped(button: UIButton){
        self.performSegueWithIdentifier("profileSegue", sender: nil )
    }
    
    func settingsButtonTapped(button: UIButton) {
        print("settings)")
        let alert = UIAlertController(title: "Settings", message: "no settings yet", preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
        alert.addAction(dismissAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        
        if indexPath.row == 0{
            let pictureCell = self.tableView.dequeueReusableCellWithIdentifier("pictureCell", forIndexPath: indexPath) as! PictureCellTableViewCell
            
           let url = NSURL(string: self.sectionUser[indexPath.section].image)
            let data = NSData(contentsOfURL: url!)
            pictureCell.pictureImageView.image = UIImage(data: data!)
            return pictureCell
        
        } else{
            let commentCell = self.tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! CommentTableViewCell
            commentCell.captionTextView.text = self.sectionUser[indexPath.section].caption
            return commentCell
        }
    }
    
//    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 450
        } else if indexPath.row == 1 {
            return 200;
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
        }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        let destination = segue.destinationViewController as! ProfileViewController
//        
//    }
}

