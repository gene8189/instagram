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


enum ActionButtonState: String {
    case CurrentUser = "Edit Profile"
    case NotFollowing = " + Follow "
    case Following = "✓ Following"
}



class ProfileViewController: UIViewController ,UICollectionViewDataSource,UICollectionViewDelegate{
    var listOfPosts = [Post]()
    
    var userId : String!
    
    @IBOutlet var actionButton: UIButton!
    
    //    var actionButtonState: ActionButtonState = .CurrentUser {
    //        willSet(newState){
    //            switch newState {
    //            case .CurrentUser:
    //                self.actionButton.backgroundColor = UIColor.init(red: 228, green: 228, blue: 228, alpha: 1.0)
    //                actionButton.layer.borderWidth = 1.0
    //            case .NotFollowing:
    //                self.actionButton.backgroundColor = UIColor.init(red: 18, green: 86, blue: 136, alpha: 1.0)
    //                actionButton.layer.borderWidth = 1.0
    //            case .Following:
    //                self.actionButton.backgroundColor = UIColor.init(red: 111, green: 187, blue: 82, alpha: 1.0)
    //                actionButton.layer.borderWidth = 1.0
    //            }
    //            actionButton.setTitle(newState.rawValue, forState: .Normal)
    //
    //        }
    //    }
    //
    
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
        self.loadImages()
    }
    

    func loadImages() {
     
//        let uid = FIRAuth.auth()!.currentUser!.uid
        let uid = userId
        DataService.usernameRef.child(uid).child("posts").observeEventType(.ChildAdded, withBlock: {(snapshot) in
            let postsRef = snapshot.key
            DataService.postRef.child(postsRef).observeSingleEventOfType(.Value, withBlock: {(postsSnapshot) in
                
                if let post = Post(snapshot: postsSnapshot){
                    self.listOfPosts.append(post)
                    self.collectionView.reloadData()
                }
                

            })
        })
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfPosts.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ImageCellCollectionViewCell
        let dict = listOfPosts[indexPath.row]
        
        
        let url = NSURL(string: dict.imageUrl)
        let data = NSData(contentsOfURL: url!)
        cell.collectionImageViewCell.image = UIImage(data: (data)!)
        
        return cell
    }
}