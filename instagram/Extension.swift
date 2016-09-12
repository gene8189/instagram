//
//  Extension.swift
//  instagram
//
//  Created by Tan Yee Gene on 11/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//
import UIKit


extension UIImage {
    func base64String() -> String {
        let imageData = UIImagePNGRepresentation(self)
        let base64String = imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        return base64String
    }
    static func imageWithBase64String(base64String : String) -> UIImage{
        let decodedData = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        let postImage = UIImage(data: decodedData!)
        return postImage!
        
    }
}