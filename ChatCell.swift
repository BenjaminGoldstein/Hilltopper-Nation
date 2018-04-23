//
//  ChatCell.swift
//  Hilltopper Nation
//
//  Created by Ben Goldstein on 4/22/18.
//  Copyright © 2018 Cyrus Illick. All rights reserved.
//
// Note: Cyrus Illick is the owner of the developers license but did not contribute to the programming of this application

import UIKit
import SwiftKeychainWrapper

class ChatCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    var title: String!
    var chatText: String!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var chat: Chat!
    //defines the current user as the one stored in the keychain, I think that it's used somewhere else in the app
    let currentUser = KeychainWrapper.standard.string(forKey: "uid")
    
    func configCell(chat: Chat) {
        self.chat = chat
        self.infoLabel.text = "\(chat.interviewer) \(chat.month)/\(chat.day)/\(chat.year)"
        self.titleLabel.text = chat.title
        self.chatText = chat.text
    }

}
