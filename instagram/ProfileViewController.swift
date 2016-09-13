//
//  ProfileViewController.swift
//  instagram
//
//  Created by Tan Yee Gene on 09/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ProfileViewController: UIViewController {
    var imageList: [UIImage] = []
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var collectionImageViewCell: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//    override func viewWillAppear(animated: Bool) {
//        let uid = FIRAuth.auth()?.currentUser?.uid
//        let profilesRef = FIRDatabase.database().reference().child("profiles")
//        let usernameRef = FIRDatabase.database().reference().child("usernames").child(uid!)
//        usernameRef.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
//            let usernameDict = snapshot.value as! String
//            profilesRef.child(usernameDict).observeSingleEventOfType(.Value, withBlock: {(snapshot2) in //
//                let profileDict = snapshot2.key as! String
//                
//                
//                
//                // i need to go to the child(key)
//            profilesRef.child(usernameDict).child("image").observeEventType(.ChildAdded, withBlock: {(snapshot3) in
//                    
//                    let imageDict = snapshot3.value as! String
//                    
//                    print(imageDict)
//                })
//            })
//        })
//    }

}
