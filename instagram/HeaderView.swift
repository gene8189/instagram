//
//  HeaderView.swift
//  
//
//  Created by Keith Piong on 09/09/2016.
//
//

import UIKit

protocol HeaderViewDelegate {
    func settingsButtonTapped(button: UIButton)
}

class HeaderView: UIView {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    var delegate: HeaderViewDelegate?
    
    @IBAction func settings(sender: UIButton) {
        self.delegate?.settingsButtonTapped(sender) //sending IBAction By Protocoling to FeedVC
        
    }
    
    


}
