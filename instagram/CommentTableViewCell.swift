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
        
        let likesRef =  DataService.rootRef.child("Usernames").child(uid).child("Photo Liked").childByAutoId() //generate auto id
        
        likesRef.setValue(likesDict)
        
//        DataService.postRef.child(uid).child("UsersWhoLiked").updateChildValues([likesRef.key: true])
//        DataService.postRef.child(uid).observeEventType(FIRDataEventType.ChildAdded, withBlock: {(snapshot) in
//            let)
        
//         DataServices.usersRef.child(User.currentUserUid).child("tweets").observeEventType(FIRDataEventType.ChildAdded, withBlock:{(snapshot) in
//                    let chatKey = snapshot.key
        
        
    }

}
