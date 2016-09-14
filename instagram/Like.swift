//
//  Like.swift
//  instagram
//
//  Created by Keith Piong on 14/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class Likes{
    
    var noOfLikes : String!
    var puid : String!
    
    init?(snapshot: FIRDataSnapshot){
        
        guard let dict = snapshot.value as? [String: AnyObject] else { return nil}
        puid = snapshot.key
        
        if let dictLikes = dict["UsersWhoLiked"] as? String{
            self.noOfLikes = dictLikes
        }else {
            self.noOfLikes = ""
        }
    }
}

