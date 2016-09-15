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
        
        startObservingDB()
        
//        let uid = FIRAuth.auth()!.currentUser!.uid
//        let currentID = DataServices.tweetRef.child(User.currentUserUid)
//        print(currentID)
    }
        func startObservingDB (){
//            DataService.postRef.child(postUid).observeEventType(.Value, withBlock: { (snapshot) in
            DataService.commentRef.observeEventType(.Value, withBlock: { (snapshot : FIRDataSnapshot) in
                var newComments = [Comment]()
                
                for comment in snapshot.children {
                    if let commentObject = Comment(snapshot: comment as! FIRDataSnapshot),
                        let userUID = commentObject.userUID{
                        newComments.append(commentObject)
                        // going to firebase to get the username
                        DataService.usernameRef.child(userUID).child("username").observeSingleEventOfType(.Value, withBlock: { (userSnapshot) in
                            commentObject.username = userSnapshot.value as? String
                            self.commentsTableView.reloadData()
                        })
                    }
                }
                self.listOfComments = newComments
                
            }) {(error:NSError) in
                print(error.description)
            }
        }


    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
///TABLE VIEW METHODS///

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOfComments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.commentsTableView.dequeueReusableCellWithIdentifier("commentsCell")!
        let comment = listOfComments.reverse()[indexPath.row]
        
        cell.textLabel?.text = comment.username
        cell.detailTextLabel?.text = comment.comment
        
        return cell
    }

    func textFieldShouldReturn(commentTextField: UITextField) -> Bool{
        
        guard let commentText = commentTextField.text else { return true }
        
        let uid = FIRAuth.auth()!.currentUser!.uid
        
        let commentDict = ["comment": commentText,
                         "created_at" : NSDate().timeIntervalSince1970,
                         "userUID" : uid]
        
//        let commentRef =  DataService.postRef.child("Comments").childByAutoId() //generate auto id
//        commentRef.updateChildValues(commentRef)
        
//        let commentRef =  DataService.rootRef.child("Comments").childByAutoId() //generate auto id
//        commentRef.setValue(commentDict)
//        
//        DataService.usernameRef.child(uid).child("Comments Sent").updateChildValues([commentRef.key: true])
//        
//        DataService.postRef.child(commentRef.key).child("Comments_Post").updateChildValues([uid: true])
//        
//        commentTextField.text = ""
//
        
        return true
        
    }
    
    
    
//    @IBAction func likeButtonPressed(sender: UIButton) {
//        let uid = FIRAuth.auth()!.currentUser!.uid
//        let likeRef = DataService.postRef.child(self.postUid).child("UsersWhoLiked")
//        let userLiked = [uid : true]
//        let photolikedRef = DataService.usernameRef.child(uid).child("PhotoLiked")
//        let photoRef = [self.postUid : true]
//        
//        likeRef.updateChildValues(userLiked)
//        photolikedRef.updateChildValues(photoRef)
//        
//    }
//}


}
