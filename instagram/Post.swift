//
//  Post.swift
//  instagram
//
//  Created by Tan Yee Gene on 09/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit

class Post{
    var creator: String
    var photo: UIImage
    var caption: String
    
    init(creator: String, photo: UIImage, caption: String){
        self.creator = creator
        self.photo = photo
        self.caption = caption
    }
}
