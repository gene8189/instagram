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

@objc protocol CommentDelegate {
//    func likes()
    func commentPost(postID: String, userID: String)
}

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var comment: UIButton!
    @IBOutlet weak var like: UIButton!
    @IBOutlet weak var share: UIButton!
    
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var commentsTextView: UITextView!
    @IBOutlet weak var likeLabel: UILabel!
    
    weak var delegate : CommentDelegate?
    
    var likesArray = [Likes]()
    var postUid: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
 
    }
   

    @IBAction func commentButtonPressed(sender: UIButton) {
        delegate?.commentPost(postUid, userID: "")
    }
    
    @IBAction func likeButtonPressed(sender: UIButton) {
        let uid = FIRAuth.auth()!.currentUser!.uid
        let likeRef = DataService.postRef.child(self.postUid).child("UsersWhoLiked")
        let userLiked = [uid : true]
        let photolikedRef = DataService.usernameRef.child(uid).child("PhotoLiked")
        let photoRef = [self.postUid : true]
        
        likeRef.updateChildValues(userLiked)
        photolikedRef.updateChildValues(photoRef)
        
    }
}
