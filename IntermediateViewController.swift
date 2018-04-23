//
//  IntermediateViewController.swift
//  Hilltopper Nation
//
//  Created by Ben Goldstein on 4/16/18.
//  Copyright © 2018 Cyrus Illick. All rights reserved.
//
// Note: Cyrus Illick is the owner of the developers license but did not contribute to the programming of this application

import UIKit
import Firebase
import SwiftKeychainWrapper

class IntermediateViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let uid = KeychainWrapper.standard.string(forKey: "uid") {
            Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
                if let listingDict = snapshot.value as? [String : AnyObject] {
                    let currentPermissions = listingDict["permissions"]! as! String
                    if currentPermissions == "Read and Write" {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let myViewController = storyboard.instantiateViewController(withIdentifier: "ContributeVC")
                        self.viewControllers = [myViewController]
                    } else {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let myViewController = storyboard.instantiateViewController(withIdentifier: "CantContributeVC") as! CantContributeVC
                        self.viewControllers = [myViewController]
                    }
                }
            }
        }
            
    }
        // Do any additional setup after loading the view.

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
