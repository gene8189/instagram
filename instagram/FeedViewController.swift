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

//protocol CommentViewDelegate {
//    
//    func commentSent(commentTextField: UITextField)
//    
//}

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HeaderViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
//    var delegate : CommentViewDelegate
    var sectionUser = [Post]()
    var likesArray = [Likes]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        DataService.postRef.observeEventType(.ChildAdded, withBlock: {(snapshot) in
            
            if let post = Post(snapshot: snapshot){
                self.sectionUser.append(post)
                self.tableView.reloadData()
            }
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
        header?.usernameLabel.setTitle("\(self.sectionUser.reverse()[section].username)", forState: .Normal)
        
        let currentUid = self.sectionUser.reverse()[section].userUID
        header?.currentUid = currentUid
        
        return header
        
    }
    
    func profileButtonTapped(button: UIButton, userUid: String){
        self.performSegueWithIdentifier("profileSegue", sender: userUid )
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
            let dict = self.sectionUser.reverse()[indexPath.section]
            
            let url = NSURL(string: dict.imageUrl)
            let data = NSData(contentsOfURL: url!)
            pictureCell.pictureImageView.image = UIImage(data: data!)
            return pictureCell
            
        } else{
            let commentCell = self.tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! CommentTableViewCell
            let post = self.sectionUser.reverse()[indexPath.section]
            commentCell.captionTextView.text = post.caption
            commentCell.postUid = post.puid
            
            ///Bug Here///
            DataService.postRef.child(post.puid).child("UsersWhoLiked").observeSingleEventOfType(.Value, withBlock: {(snapshot) in
                            if let likes = Likes(snapshot: snapshot){
                                print(likes)
                                self.likesArray.append(likes)
                                commentCell.likeLabel.text = "\(self.likesArray.count)"
                            }
                        })
            return commentCell
        }
    }
    
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "profileSegue"{
            let destination = segue.destinationViewController as! ProfileViewController
        if let userUid = sender as? String{
            destination.userId = userUid
            }
        }
    }
}

