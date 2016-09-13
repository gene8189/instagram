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

class ProfileViewController: UIViewController ,UICollectionViewDataSource,UICollectionViewDelegate{
    var listOfPosts = [Post]()
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var collectionImageViewCell: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        let uid = FIRAuth.auth()!.currentUser!.uid
        
        
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
        let picture = UIImage(data: data!)
        
        cell.collectionImageViewCell.image = picture
        
        self.collectionView.reloadData()
        return cell
    }

}
