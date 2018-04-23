//
//  TableViewController.swift
//  Hilltopper Nation
//
//  Created by Ben Goldstein on 4/12/18.
//  Copyright © 2018 Cyrus Illick. All rights reserved.
//
// Note: Cyrus Illick is the owner of the developers license but did not contribute to the programming of this application

import UIKit
import Firebase
import SwiftKeychainWrapper

class NewsVC: UITableViewController {

    var articles = [Article]()
    var articleNum: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOut))
        getArticles()
        tableView.tableFooterView = UIView()
        // Uncomment the following line to preserve selection between presentations
        //self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return articles.count
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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var errorOccurred = false
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as? ArticleCell else {
            return UITableViewCell()
        }
        if articles.count == 0 {
            return UITableViewCell()
        }
        cell.backgroundColor = UIColor(displayP3Red: 213/255, green: 213/255, blue: 213/255, alpha: 0.5)
        cell.accessoryType = .disclosureIndicator
        cell.configCell(article: self.articles[indexPath.row])
        let path = "articleImages/articlePicture\(self.articles.count - 1 - indexPath.row).jpg"
        let imgRef = Storage.storage().reference().child(path)
        imgRef.getData(maxSize: 2*1080*1080) { (data, error) in
            if error == nil {
                cell.articleImage.image = UIImage(data: data!)
            } else {
                errorOccurred = true
            }
        }
        if errorOccurred {
            return UITableViewCell()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        articleNum = indexPath.row
        performSegue(withIdentifier: "toArticle", sender: nil)
    }
    
    func getArticles() {
        Database.database().reference().child("articles").observeSingleEvent(of: .value) { (snapshot) in
            //if there aren't any posts just stop
            let snapshot = snapshot.children.allObjects as! [DataSnapshot]
            //otherwise clear the array and load in the posts from the database
            self.articles.removeAll()
            for data in snapshot.reversed() {
                guard let articleDict = data.value as? Dictionary<String, AnyObject> else { return }
                let article = Article(articleKey: data.key, articleData: articleDict)
                self.articles = self.articles + [article]
            }
            self.tableView.reloadData()
        }
    }
    
    @objc func refresh() {
        getArticles()
        self.tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.refreshControl?.endRefreshing()
        })
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let VC = segue.destination as! ArticleVC
        VC.article = articles[articleNum]
        VC.articlenum = self.articles.count - 1 - articleNum
    }

}
