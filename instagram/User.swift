//
//  User.swift
//  instagram
//
//  Created by Tan Yee Gene on 09/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//
import UIKit

class User{
    var username: String
    var email: String
    var followers: Array<String>
    var following: Array<String>
    var posts: Array<Post>
    
    init(username: String, email: String, followers: Array<String>, following: Array<String>, posts: Array<Post>){
       self.username = username
        self.email = email
        self.followers = followers
        self.following = following
        self.posts = posts

    }
    
}
