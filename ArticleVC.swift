//
//  ArticleVC.swift
//  Hilltopper Nation
//
//  Created by Ben Goldstein on 4/21/18.
//  Copyright © 2018 Cyrus Illick. All rights reserved.
//
// Note: Cyrus Illick is the owner of the developers license but did not contribute to the programming of this application

import UIKit
import Firebase

class ArticleVC: UIViewController {
    
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleAuthor: UILabel!
    @IBOutlet weak var articleDate: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleText: UITextView!
    @IBOutlet weak var textHeight: NSLayoutConstraint!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    
    var article: Article!
    var articlenum: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Article"
        articleText.text = article.text
        articleTitle.text = article.title
        articleAuthor.text = article.author
        articleDate.text = "\(article.hour):\(article.minute) \(article.ampm) \(article.month)/\(article.day)/\(article.year)"
        let path = "articleImages/articlePicture\(articlenum!).jpg"
        let imgRef = Storage.storage().reference().child(path)
        imgRef.getData(maxSize: 2*1080*1080) { (data, error) in
            self.articleImage.image = UIImage(data: data!)
        }
        textHeight.constant = CGFloat(Float(articleText.text.count) * 32 / 75 + 40)
        viewHeight.constant = textHeight.constant + CGFloat(180.0) + CGFloat(articleImage.frame.size.height)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
