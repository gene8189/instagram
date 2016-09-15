//
//  DataService.swift
//  instagram
//
//  Created by Tan Yee Gene on 13/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import Foundation
import FirebaseDatabase


struct DataService {
    
    static var rootRef = FIRDatabase.database().reference()
    static var usernameRef = FIRDatabase.database().reference().child("Usernames")
    static var postRef = FIRDatabase.database().reference().child("Posts")
    static var commentRef = FIRDatabase.database().reference().child("Comments")
    
}