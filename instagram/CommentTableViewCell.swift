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
    @IBOutlet weak var likeLabel: UILabel!
    
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
        print(self.postUid)
        
        let likeRef = DataService.postRef.child(self.postUid).child("UsersWhoLiked")
        let userLiked = [uid : true]
        let photolikedRef = DataService.usernameRef.child(uid).child("PhotoLiked")
        let photoRef = [self.postUid : true]
        
        likeRef.updateChildValues(userLiked)
        photolikedRef.updateChildValues(photoRef)
        
        
      
    }
}
