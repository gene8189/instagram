//
//  HomeTabBarController.swift
//  instagram
//
//  Created by Tan Yee Gene on 08/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit

class HomeTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cameraButton = UIButton(type : .Custom)
        let buttonImage = UIImage(named: "camera")
        let numberOfTabs = self.viewControllers!.count
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        cameraButton.frame = CGRectMake(0, 0, screenWidth/CGFloat(numberOfTabs) , self.tabBar.frame.size.height)
        cameraButton.setImage(buttonImage, forState: .Normal)
        cameraButton.center = self.tabBar.center
        cameraButton.addTarget(self, action: "PopCamera:", forControlEvents: .TouchUpInside)
        self.view.addSubview(cameraButton)
        
        
    }
    
    func PopCamera(sender: UIButton!){
        let storyBoard = UIStoryboard(name: "HomeStoryboard", bundle: NSBundle.mainBundle())
        let cameraPicker = storyBoard.instantiateViewControllerWithIdentifier("CameraPopOut")
        self.presentViewController(cameraPicker, animated: true, completion: nil)
        
        
    }
    
    
    
}
