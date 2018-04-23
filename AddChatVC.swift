//
//  AddChatVC.swift
//  Hilltopper Nation
//
//  Created by Ben Goldstein on 4/16/18.
//  Copyright © 2018 Cyrus Illick. All rights reserved.
//
// Note: Cyrus Illick is the owner of the developers license but did not contribute to the programming of this application

import UIKit
import Firebase

class AddChatVC: UIViewController {
    @IBOutlet weak var textArea: UITextView!
    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var interviewerField: UITextField!
    var hour: String!
    var amOrPm: String!
    var minute: String!
    
    var text = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Add Chat"
        if text == "" {
            self.textArea.text = "Transcription Text Here"
        } else {
            self.textArea.text = text
        }
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindSegue(_ sender: UIStoryboardSegue) {
        self.textArea.text = self.text
    }
    
    @IBAction func editTranscription(_ sender: Any) {
        performSegue(withIdentifier: "editChat", sender: nil)
    }
    
    @IBAction func submitChat(_ sender: Any) {
        if textArea.text.count < 20 || (titleField.text?.count)! < 1 || (urlField.text?.count)! < 1 || (interviewerField.text?.count)! < 1 {
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
            
            let chat: Dictionary<String, AnyObject> = [
                "hour": self.hour as AnyObject,
                "minute": self.minute as AnyObject,
                "year": year as AnyObject,
                "month": month as AnyObject,
                "day": day as AnyObject,
                "contributorFirst": contributorFirst as AnyObject,
                "contributorLast": contributorLast as AnyObject,
                "url": self.urlField.text as AnyObject,
                "ampm": self.amOrPm as AnyObject,
                "title": self.titleField.text as AnyObject,
                "text": self.textArea.text as AnyObject,
                "interviewer": self.interviewerField.text as AnyObject
            ]
            let firebaseChat = Database.database().reference().child("chats").childByAutoId()
            firebaseChat.setValue(chat)
        }) { (error) in }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! EditVC
        if let text = self.textArea.text {
            destination.text = text
        } else {
            destination.text = "Transcription Here"
        }
        destination.VCID = "AddChatVC"
        destination.image = nil
    }

}
