//
//  Profile.swift
//  instagram
//
//  Created by Tan Yee Gene on 11/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit

class Profile {
    let username: String
    var followers: [String]
    var following: [String]
    var posts: [String]
    var picture: UIImage?
    static var currentUser: Profile?
    
    init(username: String, followers: [String], following: [String], posts: [String], picture: UIImage?){
        self.username = username
        self.followers = followers
        self.following = following
        self.posts = posts
        self.picture = picture
    }
    
    static func initWithUsername(username: String , profileDict: [String: AnyObject]) -> Profile? {
        let profile = Profile.createUser(username)
        
        if let followers = profileDict["followers"] as? [String] {
            profile.followers = followers
        }
        if let following = profileDict["following"] as? [String] {
            profile.following = following
        }
        if let posts = profileDict["posts"] as? [String] {
            profile.posts = posts
        }
        if let pictureString = profileDict["picture"] as? String {
            profile.picture = UIImage.imageWithBase64String(pictureString)
        }
        return profile
    }
    
    static func createUser(username: String!) -> Profile{
        return Profile(username: username, followers: [String](), following: [String](), posts: [String](), picture: nil)
    }
    
    
    func dictValue() -> [String: AnyObject] {
        var profileDict = [String: AnyObject]()
        profileDict["username"] = username
        profileDict["followers"] = followers
        profileDict["following"] = following
        profileDict["posts"] = posts
        if let profilePicture = picture {
            profileDict["picture"] = profilePicture.base64String()
        }
        return profileDict
    }
    
}