//
//  EnterCommentViewController.swift
//  instagram
//
//  Created by Keith Piong on 14/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase



class EnterCommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    
    var listOfComments = [Comment]()
    
    var postUid: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.commentsTableView.delegate = self
        self.commentsTableView.dataSource = self
        
//        startObservingDB()
        CommentHelper.observeCommentPost(postUid) { (comment) in
            self.listOfComments = comment
            self.commentsTableView.reloadData()
        }
    }
    
//    func startObservingDB (){
//        
//        DataService.postRef.child(postUid).child("Comments_Post").observeEventType(.Value, withBlock: { (snapshot) in
//         var newComments = [Comment]()
//            
//            for commentSnapshot in snapshot.children.allObjects as! [FIRDataSnapshot] {
//                let commentKey = commentSnapshot.key
//    
//                DataService.commentRef.child(commentKey).observeSingleEventOfType(.Value, withBlock: { (commentsSnapshot) in
//                    if let commentsDict = Comment(snapshot: commentsSnapshot){
//                        newComments.append(commentsDict)
//                       
//                        // external
//                        self.commentsTableView.reloadData()
//                    }
//                    
//                    //external
//                    self.listOfComments = newComments
//                    print("list of comments \(self.listOfComments)")
//                    print("newcomments \(newComments)")
//                    // external
//                    self.commentsTableView.reloadData()
//                })
//            }
//        })
//    }
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    ///TABLE VIEW METHODS///
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOfComments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.commentsTableView.dequeueReusableCellWithIdentifier("commentsCell")!
        let comment = self.listOfComments[indexPath.row]
        let userID = self.listOfComments[indexPath.row].userUID
        
        DataService.usernameRef.child(userID!).child("username").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            let username = snapshot.value as! String
            cell.textLabel?.text = username ?? "loading.."
        })
        
        cell.detailTextLabel?.text = comment.comment ?? "loading.."
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "commentSegue" {
            let destination = segue.destinationViewController as! FeedViewController
            if let postID = sender as? String {
                destination.commentsArray = postID
            }
        }


    }
    
    func textFieldShouldReturn(commentTextField: UITextField) -> Bool{
        
        guard let commentText = commentTextField.text else { return true }
        
        let uid = FIRAuth.auth()!.currentUser!.uid
        
        let commentDict = ["comment": commentText,
                           "created_at" : NSDate().timeIntervalSince1970,
                           "userUID" : uid]
        
        let commentRef =  DataService.rootRef.child("Comments").childByAutoId() //generate auto id
        commentRef.setValue(commentDict)
        
        DataService.usernameRef.child(uid).child("Comments Sent").updateChildValues([commentRef.key: true])
        DataService.postRef.child(self.postUid).child("Comments_Post").updateChildValues([commentRef.key: true])
        
        commentTextField.text = ""
        

        return true
        
    }
}
