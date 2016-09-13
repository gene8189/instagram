//
//  FeedPosts.swift
//  instagram
//
//  Created by Keith Piong on 09/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit
import Firebase

class Post {
    var uid: String
    var caption: String?
    var image: String?
    var username: String?
    //    var profileImage : String?
    
    init?(snapshot: FIRDataSnapshot){
        
        guard let dict = snapshot.value as? [String: AnyObject] else {return nil}
        
        uid = snapshot.key
        
        if let dictCaption = dict["caption"] as? String {
            self.caption = dictCaption
        }else {
            self.caption=""
        }
        if let dictUsername = dict["username"] as? String{
            self.username = dictUsername
        }else {
            self.username = ""
        }
        if let dictImage = dict["image"] as? String{
            self.image = dictImage
        }else {
            self.image = ""
        }
    }
}
