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
import SDWebImage


enum ActionButtonState{
    case CurrentUser
    case NotFollowing
    case Following
}



class ProfileViewController: UIViewController ,UICollectionViewDataSource,UICollectionViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    var listOfPosts = [Post]()
    var userId : String!
    var username: String!
    
    @IBOutlet var actionButton: UIButton!
    var actionButtonState: ActionButtonState = .CurrentUser {
        willSet(newState){
            switch newState {
            case .CurrentUser:
                actionButton.setTitle("Edit Profile", forState: .Normal)
            case .Following:
                actionButton.setTitle("✓ Following", forState: .Normal)
            case .NotFollowing:
                actionButton.setTitle(" + Follow ", forState: .Normal)
            }
        }
        
    }
    
    
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
        self.usernameLabel.layer.borderWidth = 1
        
        if self.userId == nil{
            loadCurrentUserImages()
        }else {
            loadUserImages()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let uid = FIRAuth.auth()!.currentUser!.uid
        DataService.usernameRef.child(uid).child("username").observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            let usernameRef = snapshot.value as! String
            print("this is usernameRef \(usernameRef)")
            if  self.username ==  nil {
                self.usernameLabel.text = usernameRef
                self.actionButtonState = .CurrentUser
                
            }else if self.username == usernameRef {
                self.usernameLabel.text = usernameRef
                self.actionButtonState = .CurrentUser
            }else if self.username != usernameRef {
                self.actionButtonState = .NotFollowing
                let uid = FIRAuth.auth()!.currentUser!.uid
                DataService.usernameRef.child(uid).child("following").observeEventType(.ChildAdded, withBlock: {(followingSnapshot) in
                    let followingDict = followingSnapshot.key
                    if followingDict == self.userId {
                        self.actionButtonState = .Following
                        
                    }
                    self.usernameLabel.text = self.username
                    print("this is segued name: \(self.username)")
                })
            }
        })
    }
    
    
    
    
    func loadUserImages(){
        let uid = self.userId
        DataService.usernameRef.child(uid).child("posts").observeEventType(.ChildAdded, withBlock: {(snapshot) in
            let postsRef = snapshot.key
            DataService.postRef.child(postsRef).observeSingleEventOfType(.Value, withBlock: {(postsSnapshot) in
                
                if let post = Post(snapshot: postsSnapshot){
                    self.listOfPosts.append(post)
                    self.collectionView.reloadData()
                    self.loadProfilePic(uid)
                }
            })
        })
    }
    
    func loadCurrentUserImages() {
        
        let uid = FIRAuth.auth()!.currentUser!.uid
        //        let uid = userId
        DataService.usernameRef.child(uid).child("posts").observeEventType(.ChildAdded, withBlock: {(snapshot) in
            let postsRef = snapshot.key
            DataService.postRef.child(postsRef).observeSingleEventOfType(.Value, withBlock: {(postsSnapshot) in
                
                if let post = Post(snapshot: postsSnapshot){
                    self.listOfPosts.append(post)
                    self.collectionView.reloadData()
                    self.loadProfilePic(uid)
                    
                }
            })
        })
    }
    
    func loadProfilePic (uid: String){
        DataService.usernameRef.child(uid).observeEventType(.Value, withBlock: {(snapshot2) in
            
            if let dict = snapshot2.value as? [String: AnyObject] {
                
                guard let picInString = dict["profilePic"] as? String else {return}
                let url = NSURL(string: picInString)
                self.profileImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "loading"))
            }
        })
        
        
    }
    
    @IBAction func onEditButtonPressed(sender: UIButton) {
        switch actionButtonState {
        case .CurrentUser:
            let actionSheet = UIAlertController(title: "Edit Profile", message: "Show more skin??", preferredStyle: .ActionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            let photoAction = UIAlertAction(title: "Edit Photo", style: .Default, handler: { action in
                let picker = UIImagePickerController()
                picker.allowsEditing = true
                picker.sourceType = .PhotoLibrary
                picker.delegate = self
                self.presentViewController(picker, animated: true, completion: nil)
            })
            actionSheet.addAction(cancelAction)
            actionSheet.addAction(photoAction)
            self.presentViewController(actionSheet, animated: true, completion: nil)
        case .Following:
            
            actionButtonState = .NotFollowing
            
            
        case . NotFollowing:
            
            actionButtonState = .Following
            addFollowing()
            // remove following for currentuser and user
            
            
        }
    }
    
    func addFollowing(){
        
        let uid = FIRAuth.auth()!.currentUser!.uid
        let following = [self.userId: true]
        DataService.usernameRef.child(uid).child("following")
        let currentUserProfileFollowing = DataService.usernameRef.child(uid).child("following")
        currentUserProfileFollowing.updateChildValues(following)
        
        let followers = [uid: true]
        DataService.usernameRef.child(self.userId).child("followers")
        let userProfileFollowers = DataService.usernameRef.child(self.userId).child("followers")
        userProfileFollowers.updateChildValues(followers)
        actionButtonState = .Following
        
    }
    
    
    
    // write a function to determine if currentuser followed the user
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.profileImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        let uid = FIRAuth.auth()!.currentUser!.uid
        let filePath = "\(uid)/\(NSDate.timeIntervalSinceReferenceDate())"
        let data = UIImageJPEGRepresentation(self.profileImageView.image!, 0.5)
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpg"
        FIRStorage.storage().reference().child(filePath).putData(data!, metadata: metadata) { (metadata, error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            let fileUrl = metadata!.downloadURLs![0].absoluteString
            let imageData = ["profilePic": fileUrl]
            DataService.usernameRef.child(uid).child("profilePic")
            let userProfilePicRef = DataService.usernameRef.child(uid)
            userProfilePicRef.updateChildValues(imageData)
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfPosts.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ImageCellCollectionViewCell
        let dict = listOfPosts.reverse()[indexPath.row]
        let url = NSURL(string: dict.imageUrl)
        cell.collectionImageViewCell.sd_setImageWithURL(url, placeholderImage: UIImage(named: "loading"))
        
        
        
        return cell
    }
}