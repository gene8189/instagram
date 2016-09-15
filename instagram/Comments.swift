//
//  Comments.swift
//  instagram
//
//  Created by Keith Piong on 14/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class Comment {
    var puid : String!
    var comment: String
    var createdAt: Double
    var userUID: String?
    
    init?(snapshot: FIRDataSnapshot){
        
        guard let dict = snapshot.value as? [String: AnyObject] else { return nil }
        
        puid = snapshot.key
        
        if let dictComment = dict["comment"] as? String {
            self.comment = dictComment
            
        }else {
            self.comment = ""
        }
        if let createdAt = dict["created_at"] as? Double{
            self.createdAt = createdAt
        }else {
            self.createdAt = 0.0
        }
        self.userUID = dict["userUID"] as? String
    }
}

