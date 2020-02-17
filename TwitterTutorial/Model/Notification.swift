//
//  Notification.swift
//  TwitterTutorial
//
//  Created by Stephen Dowless on 2/10/20.
//  Copyright © 2020 Stephan Dowless. All rights reserved.
//

import Foundation

enum NotificationType: Int {
    case follow
    case like
    case reply
    case mention
}

struct Notification {
    var tweetID: String?
    var timestamp: Date!
    var user: User
    var tweet: Tweet?
    var type: NotificationType!
    
    init(user: User, dictionary: [String: AnyObject]) {
        self.user = user
                
        if let tweetID = dictionary["tweetID"] as? String {
            self.tweetID = tweetID
        }
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        
        if let type = dictionary["type"] as? Int {
            self.type = NotificationType(rawValue: type)
        }
    }
}
