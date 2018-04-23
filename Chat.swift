//
//  Chat.swift
//  Hilltopper Nation
//
//  Created by Ben Goldstein on 4/18/18.
//  Copyright © 2018 Cyrus Illick. All rights reserved.
//
// Note: Cyrus Illick is the owner of the developers license but did not contribute to the programming of this application

import Foundation
import Firebase

class Chat {
    private var _title: String!
    private var _contributorFirst: String!
    private var _contributorLast: String!
    private var _year: String!
    private var _month: String!
    private var _day: String!
    private var _hour: String!
    private var _minute: String!
    private var _url: String!
    private var _ampm: String!
    private var _interviewer: String!
    private var _text: String!
    private var _chatKey: String!
    private var _chatReference: DatabaseReference!
    
    
    
    var text: String {
        return _text
    }
    var interviewer: String {
        return _interviewer
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
    var url: String {
        return _url
    }
    var ampm: String {
        return _ampm
    }
    var chatKey: String {
        return _chatKey
    }
    var title: String {
        return _title
    }
    
    init(contributorFirst: String, contributorLast: String, year: String, month: String, day: String, hour: String, minute: String, text: String, interviewer: String, ampm: String, url: String, title: String) {
        _contributorFirst = contributorFirst
        _contributorLast = contributorLast
        _year = year
        _month = month
        _day = day
        _hour = hour
        _minute = minute
        _text = text
        _url = url
        _ampm = ampm
        _interviewer = interviewer
        _title = title
    }
    
    init(chatKey: String, chatData: Dictionary<String, AnyObject>) {
        _chatKey = chatKey
        if let contributorFirst = chatData["contributorFirst"] as? String {
            _contributorFirst = contributorFirst
        }
        if let contributorLast = chatData["contributorLast"] as? String {
            _contributorLast = contributorLast
        }
        if let year = chatData["year"] as? String {
            _year = year
        }
        if let month = chatData["month"] as? String {
            _month = month
        }
        if let day = chatData["day"] as? String {
            _day = day
        }
        if let hour = chatData["hour"] as? String {
            _hour = hour
        }
        if let minute = chatData["minute"] as? String {
            _minute = minute
        }
        if let url = chatData["url"] as? String {
            _url = url
        }
        if let ampm = chatData["ampm"] as? String {
            _ampm = ampm
        }
        if let title = chatData["title"] as? String {
            _title = title
        }
        if let text = chatData["text"] as? String {
            _text = text
        }
        if let interviewer = chatData["interviewer"] as? String {
            _interviewer = interviewer
        }
        _chatReference = Database.database().reference().child("chats").child(_chatKey)
    }
}
