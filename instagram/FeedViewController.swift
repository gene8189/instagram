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
    var currentUsername : String!
    var dict = [Post]()
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
        let uid = self.sectionUser.reverse()[section].userUID
        let header = NSBundle.mainBundle().loadNibNamed("headerVIew", owner: 0, options: nil)[0] as? HeaderView
        header?.delegate = self
        header?.usernameLabel.setTitle("\(self.sectionUser.reverse()[section].username)", forState: .Normal)
        DataService.usernameRef.child(uid).observeEventType(.Value, withBlock: {(snapshot2) in
            
            if let dict = snapshot2.value as? [String: AnyObject] {
                
                guard let picInString = dict["profilePic"] as? String else {return}
                let url = NSURL(string: picInString)
                header?.profileImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "loading"))
                let currentUid = self.sectionUser.reverse()[section].userUID
                self.currentUsername = self.sectionUser.reverse()[section].username
                header?.currentUid = currentUid
                
                
            }
        })
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
        
        //        delegate!.commentSent(self, text: colorLabel.text)
        
        if indexPath.row == 0{
            let pictureCell = self.tableView.dequeueReusableCellWithIdentifier("pictureCell", forIndexPath: indexPath) as! PictureCellTableViewCell
            let dict = self.sectionUser.reverse()[indexPath.section]
            
            
            let url = NSURL(string: dict.imageUrl)
            pictureCell.pictureImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "loading"))
            
            
            return pictureCell
            
        } else{
            let commentCell = self.tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! CommentTableViewCell
            let post = self.sectionUser.reverse()[indexPath.section]
            commentCell.captionTextView.text = post.caption
            commentCell.postUid = post.puid
            DataService.postRef.child(post.puid).child("UsersWhoLiked").observeEventType(.Value, withBlock: {(snapshot) in
                let numLikes = snapshot.childrenCount
               commentCell.likeLabel.text = "\(numLikes)"
            })
            return commentCell
        }
    }

    
    func likesCount(snapshot: FIRDataSnapshot){

        
        //        if let dict = snapshot2.value as? [String: AnyObject] {
        //
        //            guard let picInString = dict["profilePic"] as? String else {return}
        //            let url = NSURL(string: picInString)
        


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
                destination.username = self.currentUsername
            }
        }
    }
}

