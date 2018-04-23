//
//  article.swift
//  Hilltopper Nation
//
//  Created by Ben Goldstein on 4/17/18.
//  Copyright © 2018 Cyrus Illick. All rights reserved.
//
// Note: Cyrus Illick is the owner of the developers license but did not contribute to the programming of this application

import Foundation
import Firebase

class Article {
    private var _title: String!
    private var _contributorFirst: String!
    private var _contributorLast: String!
    private var _year: String!
    private var _month: String!
    private var _day: String!
    private var _hour: String!
    private var _minute: String!
    private var _text: String!
    private var _ampm: String!
    private var _author: String!
    private var _articleKey: String!
    private var _articleReference: DatabaseReference!
    
    
    var author: String {
        return _author
    }
    var contributorFirst: String {
        return _contributorFirst
    }
    var contributorLast: String {
        return _contributorLast
    }
    var year: String {
        return _year
    }
    var month: String {
        return _month
    }
    var day: String {
        return _day
    }
    var hour: String {
        return _hour
    }
    var minute: String {
        return _minute
    }
    var text: String {
        return _text
    }
    var ampm: String {
        return _ampm
    }
    var articleKey: String {
        return _articleKey
    }
    var title: String {
        return _title
    }
    
    init(contributorFirst: String, contributorLast: String, year: String, month: String, day: String, hour: String, minute: String, text: String, author: String, ampm: String, title: String) {
            _contributorFirst = contributorFirst
            _contributorLast = contributorLast
            _year = year
            _month = month
            _day = day
            _hour = hour
            _minute = minute
            _text = text
            _author = author
            _title = title
            _ampm = ampm
    }
    
    init(articleKey: String, articleData: Dictionary<String, AnyObject>) {
        _articleKey = articleKey
        if let contributorFirst = articleData["contributorFirst"] as? String {
            _contributorFirst = contributorFirst
        }
        if let contributorLast = articleData["contributorLast"] as? String {
            _contributorLast = contributorLast
        }
        if let year = articleData["year"] as? String {
            _year = year
        }
        if let month = articleData["month"] as? String {
            _month = month
        }
        if let day = articleData["day"] as? String {
            _day = day
        }
        if let hour = articleData["hour"] as? String {
            _hour = hour
        }
        if let minute = articleData["minute"] as? String {
            _minute = minute
        }
        if let text = articleData["text"] as? String {
            _text = text
        }
        if let ampm = articleData["ampm"] as? String {
            _ampm = ampm
        }
        if let title = articleData["title"] as? String {
            _title = title
        }
        if let author = articleData["author"] as? String {
            _author = author
        }
        _articleReference = Database.database().reference().child("articles").child(_articleKey)
    }
    
}
