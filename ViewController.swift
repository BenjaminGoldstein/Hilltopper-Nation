//
//  ViewController.swift
//  Hilltopper Nation
//
//  Created by Ben Goldstein on 4/10/18.
//  Copyright © 2018 Cyrus Illick. All rights reserved.
//
// Note: Cyrus Illick is the owner of the developers license but did not contribute to the programming of this application

import UIKit
import Firebase
import SwiftKeychainWrapper

class ViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var outerStackView: UIStackView!
    @IBOutlet weak var outerStackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var outerStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lowerStackView: UIStackView!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    var tempID: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if errorLabel.text == "" {
            errorLabel.isHidden = true
        }
        self.outerStackViewTopConstraint.constant = 20
        var x: CGFloat!
        x = 0
        if self.view.frame.size.height == 812 || self.view.frame.size.height == 736  {
            x = 50
        }
        
        self.outerStackViewHeightConstraint.constant = view.frame.size.height - 50 - x
        //see if keyboard is shown
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        self.outerStackView.translatesAutoresizingMaskIntoConstraints = false
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        //when keyboard is hidden return text fields to original position
        UIView.animate(withDuration: 0.25, animations: {
            self.outerStackViewTopConstraint.constant = 20
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func KeyboardWillShow(notification: NSNotification!) {
        //figure out which text field is being used and which stack view it's in
        var textField: UITextField! = self.passwordField
        if emailField.isFirstResponder {
            textField = emailField
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //if user info is already in keychain go directly to feed
        if KeychainWrapper.standard.string(forKey: "uid") != nil {
            self.performSegue(withIdentifier: "toApp", sender: nil)
        }
    }

    @IBAction func toRegister(_ sender: UIButton) {
        performSegue(withIdentifier: "toRegister", sender: nil)
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        if let email = emailField.text, let password = passwordField.text {
            //try to sign the user in
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                //if email and password are not right and user name and school are filled assume they're trying to create account and create
                if error != nil {
                    self.errorLabel.text = "Incorrect email or password"
                    self.errorLabel.isHidden = false
                }
                else {
                    //if email and password are right sign the user in, store info in keychain, go to feed
                        if Auth.auth().currentUser!.isEmailVerified {
                            if let userID = user?.uid {
                                KeychainWrapper.standard.set((userID), forKey: "uid")
                                self.performSegue(withIdentifier: "toApp", sender: nil)
                            }
                        } else {
                                self.tempID = user?.uid
                                Auth.auth().currentUser!.sendEmailVerification { (error) in }
                            self.performSegue(withIdentifier: "toVerification", sender: nil)
                        }
                    }
                }
            }
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "verification") as! VerificationVC
        VC.userID = tempID
    }
    
}

extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue!])
        }
    }
}

