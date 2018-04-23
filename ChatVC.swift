//
//  ChatVC.swift
//  Hilltopper Nation
//
//  Created by Ben Goldstein on 4/22/18.
//  Copyright © 2018 Cyrus Illick. All rights reserved.
//
// Note: Cyrus Illick is the owner of the developers license but did not contribute to the programming of this application

import UIKit

class ChatVC: UIViewController {
    
    @IBOutlet weak var chatText: UITextView!
    @IBOutlet weak var chatTitle: UILabel!
    @IBOutlet weak var chatInterviewer: UILabel!
    @IBOutlet weak var chatTimeStamp: UILabel!
    @IBOutlet weak var videoView: UIWebView!
    @IBOutlet weak var textHeight: NSLayoutConstraint!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    var chat: Chat!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Chat"
        chatText.text = chat.text
        chatTitle.text = chat.title
        chatInterviewer.text = chat.interviewer
        chatTimeStamp.text = "\(chat.hour):\(chat.minute) \(chat.ampm) \(chat.month)/\(chat.day)/\(chat.year)"
        getVideo(url: chat.url)
        textHeight.constant = CGFloat(Float(chatText.text.count) * 36 / 75 + 40)
        viewHeight.constant = textHeight.constant + CGFloat(180.0) + CGFloat(videoView.frame.size.height)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getVideo(url: String) {
        var equalSignFound = false
        var videoCode = ""
        for char in url {
            if equalSignFound {
                videoCode = videoCode + String(char)
            }
            if char == "=" {
                equalSignFound = true
            }
        }
        let address = URL(string: "https://www.youtube.com/embed/\(videoCode)")
        videoView.loadRequest(URLRequest(url: address!))
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
