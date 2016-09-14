//
//  CommentTableViewCell.swift
//  instagram
//
//  Created by Keith Piong on 09/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth



class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var comment: UIButton!
    @IBOutlet weak var like: UIButton!
    @IBOutlet weak var share: UIButton!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var commentsTextView: UITextView!
    
    var likesArray = [String]()
    var postUid: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }

    
    @IBAction func likeButtonPressed(sender: UIButton) {
        let uid = FIRAuth.auth()!.currentUser!.uid
        
        let likesDict = ["created_at" : NSDate().timeIntervalSince1970,
                         "userUID" : uid]
        print(self.postUid)
       
        
        
        let likeRef = DataService.postRef.child(self.postUid).child("UsersWhoLiked")
        let userLiked = [uid : true]
        let photolikedRef = DataService.usernameRef.child(uid).child("PhotoLiked")
        let photoRef = [self.postUid : true]
        likeRef.setValue(userLiked)
        photolikedRef.updateChildValues(photoRef)
        
//        let likesRef =  DataService.rootRef.child("Usernames").child(uid).child("Photos Liked").childByAutoId() //generate auto id
//        
//        likesRef.setValue(likesDict)
//        
//            
//        })
//        let likesRef =  DataService.rootRef.child("Usernames").child(uid).child("Photos Liked").childByAutoId() //generate auto id
//        likesRef.setValue(likesDict)
//
//         DataService.usernameRef.child(uid).child("posts").observeEventType(FIRDataEventType.ChildAdded, withBlock:{(snapshot) in
//                    let postKey = snapshot.key
        
//            DataService.postRef.child(postKey).child("UsersWhoLiked").observeSingleEventOfType(.ChildAdded, withBlock: { (likesSnapshot) in
//        
//        DataService.
//            
//                DataService.postRef.child(postKey).child("UsersWhoLiked").updateChildValues([likesRef.key: true])
//         })
//    }
//    

    }
}
