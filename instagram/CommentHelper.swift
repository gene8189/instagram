//
//  CommentHelper.swift
//  instagram
//
//  Created by Keith Piong on 15/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import Foundation
import FirebaseDatabase

class CommentHelper {

    static func observeCommentPost(postID: String, completion:([Comment] -> Void)){
        
        DataService.postRef.child(postID).child("Comments_Post").observeEventType(.Value, withBlock: { (snapshot) in
            var newComments = [Comment]()
            
            for commentSnapshot in snapshot.children.allObjects as! [FIRDataSnapshot] {
                let commentKey = commentSnapshot.key
                
                DataService.commentRef.child(commentKey).observeSingleEventOfType(.Value, withBlock: { (commentsSnapshot) in
                    if let commentsDict = Comment(snapshot: commentsSnapshot){
                        newComments.append(commentsDict)
                    }
                    completion(newComments)
                })
            }
        })
    }
}