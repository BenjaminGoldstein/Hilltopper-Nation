//
//  EditVC.swift
//  Hilltopper Nation
//
//  Created by Ben Goldstein on 4/17/18.
//  Copyright © 2018 Cyrus Illick. All rights reserved.
//
// Note: Cyrus Illick is the owner of the developers license but did not contribute to the programming of this application

import UIKit

class EditVC: UIViewController {
    
    
    @IBOutlet weak var textArea: UITextView!
    var text: String!
    var VCID: String!
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textArea.text = text
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if VCID == "AddArticleVC" {
            let VC = segue.destination as! AddArticleVC
            VC.text = self.textArea.text
        } else {
            let VC = segue.destination as! AddChatVC
            VC.text = self.textArea.text
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
