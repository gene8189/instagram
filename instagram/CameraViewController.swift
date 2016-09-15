//
//  CameraViewController.swift
//  instagram
//
//  Created by Tan Yee Gene on 08/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import Firebase

class CameraViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, CaptionDelegate {
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var selectPhotoButton: UIButton!
    var creator: String!
    @IBOutlet var imageView: UIImageView!
    var selectedImage: UIImage?
    @IBOutlet var photoLabel: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photoLabel.text = "Photo"
        
        self.takePhotoButton.layer.cornerRadius = 2;
        self.takePhotoButton.layer.borderWidth = 1;
        self.takePhotoButton.layer.borderColor = UIColor.blackColor().CGColor
        self.selectPhotoButton.layer.cornerRadius = 2;
        self.selectPhotoButton.layer.borderWidth = 1;
        self.selectPhotoButton.layer.borderColor = UIColor.blackColor().CGColor
    }
    
    
    @IBAction func onXButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSelectPhotoButtonPressed(sender: AnyObject) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .PhotoLibrary
        picker.delegate = self
        self.presentViewController(picker, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.selectedImage = info[UIImagePickerControllerEditedImage] as? UIImage
        self.imageView.image = self.selectedImage
        if picker.sourceType == .Camera {
            self.photoLabel.text = "Camera"
        }else if picker.sourceType == .PhotoLibrary {
            self.photoLabel.text = "Library"
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController as! CaptionViewController
        destination.selectedImage = self.selectedImage
        destination.delegate = self
        
        
    }
    
    func captionDelegate(controller: CaptionViewController, didFinishEditImage caption: String) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        guard let postImage = selectedImage else {
            print("No Image")
            return
        }
        
        let uid = FIRAuth.auth()!.currentUser!.uid
        DataService.usernameRef.child(uid).child("username").observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            let usernameRef = snapshot.value as! String
            print("this is usernameRef \(usernameRef)")
        
            // sending image into storage
            let filePath = "\(uid)/\(NSDate.timeIntervalSinceReferenceDate()))"
            let data = UIImageJPEGRepresentation(postImage, 0.5)!
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpg"
            FIRStorage.storage().reference().child(filePath).putData(data, metadata: metadata, completion: { (metadata, error) in
                if error != nil {
                    print(error?.localizedDescription)
                    return
                }
                
                let fileUrl = metadata!.downloadURLs![0].absoluteString
                let caption = caption
                let imageData = ["image":fileUrl, "caption": caption, "username" : usernameRef, "userUID": uid]
                let postRef = DataService.postRef.childByAutoId()
                postRef.setValue(imageData)
                DataService.usernameRef.child(uid).child("posts").updateChildValues([postRef.key : true])
            })
        })
        let tabBarController = self.presentingViewController as? HomeTabBarController
        tabBarController!.selectedIndex  = 0
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func onTakePhotoButtonPressed(sender: AnyObject) {
        let photoPicker = UIImagePickerController()
        photoPicker.allowsEditing = true
        photoPicker.sourceType = .Camera
        photoPicker.delegate = self
        self.presentViewController(photoPicker, animated: true, completion: nil)
        
        
        
    }
    
}


