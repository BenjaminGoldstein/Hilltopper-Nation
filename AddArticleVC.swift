//
//  AddArticleVC.swift
//  Hilltopper Nation
//
//  Created by Ben Goldstein on 4/16/18.
//  Copyright © 2018 Cyrus Illick. All rights reserved.
//
// Note: Cyrus Illick is the owner of the developers license but did not contribute to the programming of this application

import UIKit
import Firebase

class AddArticleVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var minute: String!
    var hour: String!
    var amOrPm: String!
    @IBOutlet weak var textArea: UITextView!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var error: UILabel!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var authorField: UITextField!
    var text = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Add Article"
        if text == "" {
            self.textArea.text = "Article Text Here"
        } else {
            self.textArea.text = text
        }
        error.isHidden = true
        if articleImage.image == nil {
            articleImage.image = #imageLiteral(resourceName: "default")
        }
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editArticle(_ sender: Any) {
        performSegue(withIdentifier: "editArticle", sender: nil)
    }
    @IBAction func uploadImage(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            articleImage.image = image
        } else {
            self.error.isHidden = false
            self.error.text = "Error Retrieving Image"
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unwindSegue(_ sender: UIStoryboardSegue) {
        self.textArea.text = self.text
    }
    
    @IBAction func addArticle(_ sender: Any) {
        if textArea.text.count < 20 || (titleField.text?.count)! < 1 || articleImage.image == nil || (authorField.text?.count)! < 1{
            self.error.isHidden = false
            self.error.text = "Fill all fields and upload imageg"
            return
        }
        let date = Date()
        let calendar = Calendar.current
        let month = "\(calendar.component(.month, from: date))"
        let day = "\(calendar.component(.day, from: date))"
        let year = "\(calendar.component(.year, from: date))"
        if calendar.component(.hour, from: date) > 12 {
            hour = "\(calendar.component(.hour, from: date) - 12)"
            amOrPm = "PM"
        }
        else if calendar.component(.hour, from: date) == 0 {
            hour = "12"
            amOrPm = "AM"
        }
        else {
            hour = "\(calendar.component(.hour, from: date))"
            amOrPm = "AM"
        }
        if calendar.component(.minute, from: date) < 10 {
            minute = "0\(calendar.component(.minute, from: date))"
        }
        else {
            minute = "\(calendar.component(.minute, from: date))"
        }
        let userID = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let data = snapshot.value as! Dictionary<String, AnyObject>
            let contributorFirst = data["firstName"]
            let contributorLast = data["lastName"]
            
            let article: Dictionary<String, AnyObject> = [
                "hour": self.hour as AnyObject,
                "minute": self.minute as AnyObject,
                "year": year as AnyObject,
                "month": month as AnyObject,
                "day": day as AnyObject,
                "contributorFirst": contributorFirst as AnyObject,
                "contributorLast": contributorLast as AnyObject,
                "text": self.textArea.text as AnyObject,
                "ampm": self.amOrPm as AnyObject,
                "title": self.titleField.text as AnyObject,
                "author": self.authorField.text as AnyObject
            ]
            let firebaseArticle = Database.database().reference().child("articles").childByAutoId()
            firebaseArticle.setValue(article)
            }) { (error) in }
            let storage = Storage.storage().reference()
            let database = Database.database().reference()
            database.child("articles").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let number = value!.count - 1
                let image = self.articleImage.image
                let metaData = StorageMetadata()
                metaData.contentType = "image/jpeg"
                let path = "articleImages/articlePicture\(number).jpg"
                let tempImageRef = storage.child(path)
                tempImageRef.putData(UIImageJPEGRepresentation(image!, 0.2)!, metadata: metaData) { (data, error) in
                    if error == nil {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        self.error.text = (error?.localizedDescription)! + "Please Report Bug"
                    }
                }
            }) { (error) in
                self.error.text = (error.localizedDescription) + "Please Report Bug"
            }
            //after done posting brings user back to feed
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! EditVC
        if let text = self.textArea.text {
            destination.text = text
        } else {
            destination.text = "Article Text Here"
        }
        destination.VCID = "AddArticleVC"
        destination.image = self.articleImage.image
    }

}
