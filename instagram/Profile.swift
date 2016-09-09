//
//  Profile.swift
//  instagram
//
//  Created by Tan Yee Gene on 09/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit

class Profile{
    var username: String
    var posts: Array<Post>
    var followers: Array<String>
    var following: Array<String>
    var email: String
    var photo: UIImage
    
    init(username: String, email: String, followers: Array<String>, following: Array<String>, photo: UIImage, posts: Array<Post>){
        self.username = username
        self.email = email
        self.followers = followers
        self.following = following
        self.photo = photo
        self.posts = posts
    }
    
}
