//
//  Posts.swift
//  instagram
//
//  Created by Tan Yee Gene on 13/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import Foundation
import FirebaseDatabase


class Post{
    var caption: String
    var username : String
    var imageUrl : String
    var uid : String
    
    init?(snapshot: FIRDataSnapshot){
        
        guard let dict = snapshot.value as? [String: AnyObject] else { return nil}
        uid = snapshot.key
        
        if let dictCaption = dict["caption"] as? String{
            self.caption = dictCaption
        }else {
            self.caption = ""
        }
        if let dictUsername = dict["username"] as? String{
            self.username = dictUsername
        }else{
            self.username = ""
        }
        if let dictImage = dict["image"] as? String {
            
            self.imageUrl = dictImage
            
        }else {
            self.imageUrl = ""
        }
    }
}
