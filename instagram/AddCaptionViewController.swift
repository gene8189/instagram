//
//  AddCaptionViewController.swift
//  instagram
//
//  Created by Tan Yee Gene on 09/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit

protocol CaptionDelegate{
    func captionController(controller: AddCaptionViewController, didFinishWithCaption caption: String)
}
class AddCaptionViewController: UIViewController {
    @IBOutlet var captionText: UITextView!

    @IBOutlet var imageView: UIImageView!
    var selectedImage: UIImage!
    var delegate: CaptionDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = self.selectedImage
    }
    
    @IBAction func onBackButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onShareButtonPressed(sender: AnyObject) {
        if let captionDelegate = self.delegate {
        captionDelegate.captionController(self, didFinishWithCaption: captionText.text)
        }
        
        
    }

}
