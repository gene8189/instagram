//
//  CaptionViewController.swift
//  instagram
//
//  Created by Tan Yee Gene on 09/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit
protocol CaptionDelegate {
   func captionDelegate(controller: CaptionViewController, didFinishEditImage caption: String)
}
class CaptionViewController: UIViewController {

    @IBOutlet var captionText: UITextView!
    var delegate: CaptionDelegate?
    @IBOutlet var imageView: UIImageView!
    var selectedImage: UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = selectedImage

    }
    @IBAction func onBackButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onShareButtonPressed(sender: AnyObject) {
        if let captionDelegate = self.delegate{
            captionDelegate.captionDelegate(self, didFinishEditImage:self.captionText.text)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
