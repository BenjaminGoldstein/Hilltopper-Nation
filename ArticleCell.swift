//
//  ArticleCell.swift
//  Hilltopper Nation
//
//  Created by Ben Goldstein on 4/18/18.
//  Copyright © 2018 Cyrus Illick. All rights reserved.
//
// Note: Cyrus Illick is the owner of the developers license but did not contribute to the programming of this application

import UIKit
import Firebase
import SwiftKeychainWrapper

class ArticleCell: UITableViewCell {
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleDateAndContributor: UILabel!
    var title: String!
    var articleText: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var article: Article!
    //defines the current user as the one stored in the keychain, I think that it's used somewhere else in the app
    let currentUser = KeychainWrapper.standard.string(forKey: "uid")
    
    func configCell(article: Article) {
        self.article = article
        self.articleDateAndContributor.text = "\(article.author) \(article.month)/\(article.day)/\(article.year)"
        self.articleTitle.text = article.title
        self.articleText = article.text
    }

}
