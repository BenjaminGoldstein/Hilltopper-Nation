//
//  ChatsVC.swift
//  Hilltopper Nation
//
//  Created by Ben Goldstein on 4/22/18.
//  Copyright © 2018 Cyrus Illick. All rights reserved.
//
// Note: Cyrus Illick is the owner of the developers license but did not contribute to the programming of this application

import UIKit
import Firebase
import SwiftKeychainWrapper

class ChatsVC: UITableViewController {

    var chats = [Chat]()
    var chatNum: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOut))
        getChats()
        tableView.tableFooterView = UIView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "camolite"))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Refreshing")
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return chats.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as? ChatCell else {
            return UITableViewCell()
        }
        if chats.count == 0 {
            return UITableViewCell()
        }
        
        cell.backgroundColor = UIColor(displayP3Red: 213, green: 213, blue: 213, alpha: 0.5)
        cell.accessoryType = .disclosureIndicator
        cell.configCell(chat: self.chats[indexPath.row])
        // Configure the cell...
        return cell
    }

    @objc func signOut (_ sender: AnyObject) {
        KeychainWrapper.standard.removeObject(forKey: "uid")
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.present(viewController, animated: true, completion: nil)
    }
    
    func getChats() {
        Database.database().reference().child("chats").observeSingleEvent(of: .value) { (snapshot) in
            //if there aren't any posts just stop
            let snapshot = snapshot.children.allObjects as! [DataSnapshot]
            //otherwise clear the array and load in the posts from the database
            self.chats.removeAll()
            for data in snapshot.reversed() {
                guard let chatDict = data.value as? Dictionary<String, AnyObject> else { return }
                let chat = Chat(chatKey: data.key, chatData: chatDict)
                self.chats.append(chat)
            }
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chatNum = indexPath.row
        performSegue(withIdentifier: "toChat", sender: nil)
    }
    
    @objc func refresh() {
        getChats()
        self.tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.refreshControl?.endRefreshing()
        })
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let VC = segue.destination as! ChatVC
        VC.chat = chats[chatNum]
    }

}
