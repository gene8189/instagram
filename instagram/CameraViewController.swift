//
//  CameraViewController.swift
//  instagram
//
//  Created by Tan Yee Gene on 08/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, CaptionDelegate {

    @IBOutlet var imageView: UIImageView!
    
      var selectedImage : UIImage?

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
    
    @IBAction func onTakePhotoButtonPressed(sender: AnyObject) {
        let photoPicker = UIImagePickerController()
        photoPicker.allowsEditing = true
        photoPicker.sourceType = .Camera
        photoPicker.delegate = self
        self.presentViewController(photoPicker, animated: true, completion: nil)
        
    }
    
    func captionController(controller: AddCaptionViewController, didFinishWithCaption caption: String) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        selectedImage = info[UIImagePickerControllerEditedImage] as? UIImage
        self.imageView.image = selectedImage
        if picker.sourceType == .Camera{
            self.photoLabel.text = "PHOTO"
        }else if picker.sourceType == .PhotoLibrary{
            self.photoLabel.text = "LIBRARY"
        }
            picker.dismissViewControllerAnimated(true, completion: nil)                  
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController as! AddCaptionViewController
        destination.selectedImage = selectedImage
        destination.delegate = self
        
    }
}
