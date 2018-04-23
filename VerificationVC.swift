//
//  VerificationVC.swift
//  Hilltopper Nation
//
//  Created by Ben Goldstein on 4/22/18.
//  Copyright © 2018 Cyrus Illick. All rights reserved.
//
// Note: Cyrus Illick is the owner of the developers license but did not contribute to the programming of this application

import UIKit
import Firebase
import SwiftKeychainWrapper

class VerificationVC: UIViewController {

    
    var userID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func verified(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resend(_ sender: Any) {
        Auth.auth().currentUser!.sendEmailVerification { (error) in }
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
