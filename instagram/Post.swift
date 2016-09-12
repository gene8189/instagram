//
//  Post.swift
//  instagram
//
//  Created by Tan Yee Gene on 09/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit

class Post{
    let creator: String
    let timestamp: NSDate
    let image: UIImage
    let caption: String
    let postID: String?
    static var feed: Array<Post>?
    
    
    init(id: String? , creator: String, image: UIImage, caption: String?){
        self.postID = id
        self.creator = creator
        self.image = image
        self.caption = caption!
        timestamp = NSDate()
    }
    
    static func initWithPostID(postID: String, postDict : [String:String])-> Post?{
        guard let creator = postDict["creator"], let base64String = postDict["image"] else {
            return nil
        }
        let caption = postDict["caption"]
        let image = UIImage.imageWithBase64String(base64String)
        return Post(id: postID, creator: creator, image: image, caption: caption)
    }
    
    func dictValue() -> [String: String] {
        var postDict = [String:String]()
        postDict["creator"] = creator
        postDict["image"] = image.base64String()
        postDict["caption"] = caption
        return postDict
        
    }
}

