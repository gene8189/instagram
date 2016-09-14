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
    
    func profileButtonTapped(button: UIButton, userUid: String)
}

class HeaderView: UIView {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UIButton!
    var delegate: HeaderViewDelegate?
    var currentUid: String!
    
    @IBAction func settings(sender: UIButton) {
        self.delegate?.settingsButtonTapped(sender) //sending IBAction By Protocoling to FeedVC
        
    }
    
    @IBAction func profileButton(sender: UIButton) {
        
        self.delegate?.profileButtonTapped(sender, userUid: currentUid)
    }

}
