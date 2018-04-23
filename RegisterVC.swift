//
//  RegisterVC.swift
//  Hilltopper Nation
//
//  Created by Ben Goldstein on 4/10/18.
//  Copyright © 2018 Cyrus Illick. All rights reserved.
//
// Note: Cyrus Illick is the owner of the developers license but did not contribute to the programming of this application

import UIKit
import Firebase
import SwiftKeychainWrapper

class RegisterVC: UIViewController {
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var error: UILabel!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirm: UITextField!
    @IBOutlet weak var outerStackView: UIStackView!
    @IBOutlet weak var lowerStackView: UIStackView!
    @IBOutlet weak var outerStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var outerStackViewTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        error.clipsToBounds = true
        error.layer.cornerRadius = 5.0
        error.frame.size.height = 30
        error.isHidden = true
        self.outerStackViewTopConstraint.constant = 10
        var x: CGFloat!
        x = 0
        if self.view.frame.size.height == 812 || self.view.frame.size.height == 736  {
            x = 60
        }
        self.outerStackViewHeightConstraint.constant = view.frame.size.height - 40 - x
        //see if keyboard is shown
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        self.outerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func register(_ sender: UIButton) {
        if password.text == ""{
            error.text = "Please Enter Password"
            error.isHidden = false
        }
        else if email.text == "" {
            error.text = "Please Enter Email"
            error.isHidden = false
        }
        else if password.text != confirm.text {
            error.text = "Passwords Don't Match"
            error.isHidden = false
        } else if firstName.text == "" || lastName.text == "" {
            error.text = "Please Enter Name Information"
            error.isHidden = false
        } else if email.text!.lowercased().range(of: "hopkins.edu") == nil {
            error.text = "Please Use Your Hopkins Email"
            error.isHidden = false
        }
        else {
            let emailtext = self.email.text!.lowercased(), passwordtext = self.password.text!
            Auth.auth().createUser(withEmail: emailtext, password: passwordtext) { (user, error) in
                if error == nil {
                    self.setupUser(userUid: (user?.uid)!)
                    //store info in keychain
                    self.performSegue(withIdentifier: "backToSignIn", sender: nil)
                } else {
                    self.error.text = "error creating account, please retry"
                }
            }
        }
    }
    
    func setupUser(userUid: String) {
        //set a user's data to what they enter when creating account
        let userData = [
            "firstName": self.firstName.text!,
            "lastName": self.lastName.text!,
            "permissions": "Read Only"
            ] as [String : Any]
        //store users data in the database and go to feed
        Database.database().reference().child("users").child(userUid).setValue(userData)
    }
    
    @IBAction func `return`(_ sender: UIButton) {
        self.performSegue(withIdentifier: "backToSignIn", sender: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        //when keyboard is hidden return text fields to original position
        UIView.animate(withDuration: 0.25, animations: {
            self.outerStackViewTopConstraint.constant = 10
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func KeyboardWillShow(notification: NSNotification!) {
        //figure out which text field is being used and which stack view it's in
        var textField: UITextField! = password
        if password.isFirstResponder {
            textField = password
        }
        else if email.isFirstResponder {
            textField = email
        }
        else if firstName.isFirstResponder {
            textField = firstName
        }
        else if lastName.isFirstResponder {
            textField = lastName
        }
        else if confirm.isFirstResponder {
            textField = confirm
        }
        //move entire view so that text field in use is right above keyboard
        if let info = notification.userInfo {
            let rect:CGRect = info["UIKeyboardFrameEndUserInfoKey"] as! CGRect
            let targetY = view.frame.size.height - rect.height - 15 - textField.frame.size.height
            let textFieldY = outerStackView.frame.origin.y + lowerStackView.frame.origin.y + textField.frame.origin.y
            let difference = targetY - textFieldY
            let targetOffsetForTopConstraint = outerStackViewTopConstraint.constant + difference
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.25, animations: {
                self.outerStackViewTopConstraint.constant = targetOffsetForTopConstraint
                self.view.layoutIfNeeded()
            })
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    */

}
