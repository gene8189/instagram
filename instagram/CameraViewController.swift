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
    var creator: String!
    @IBOutlet var imageView: UIImageView!
    var selectedImage: UIImage?
    @IBOutlet var photoLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photoLabel.text = "Photo"
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
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        DataService.usernameRef.child(uid!).child("username").observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            let usernameRef = snapshot.value as! String
            print(usernameRef)
      
            let filePath = "\(FIRAuth.auth()!.currentUser!)/\(NSDate.timeIntervalSinceReferenceDate())"
            let data = UIImageJPEGRepresentation(postImage, 1)
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpg"
            FIRStorage.storage().reference().child(filePath).putData(data!, metadata: metadata) { (metadata, error) in
                if error != nil {
                    print(error?.localizedDescription)
                    return
                }
                let imageString = data!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
                let caption = caption
                let imageData = ["image":imageString, "caption": caption, "username" : usernameRef]
                
                
                let postRef = DataService.postRef.childByAutoId()
                postRef.setValue(imageData)
                DataService.usernameRef.child(uid!).child("posts").updateChildValues([postRef.key : true])
            }
          })
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


