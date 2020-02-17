//
//  NotificationService.swift
//  TwitterTutorial
//
//  Created by Stephen Dowless on 2/10/20.
//  Copyright © 2020 Stephan Dowless. All rights reserved.
//

import Firebase

struct NotificationService {
    static let shared = NotificationService()
    
    func uploadNotification(toUser user: User,
                            type: NotificationType,
                            tweetID: String? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var values: [String: Any] = ["timestamp": Int(NSDate().timeIntervalSince1970),
                                     "uid": uid,
                                     "type": type.rawValue]
        
        if let tweetID = tweetID {
            values["tweetID"] = tweetID
        }
        
        REF_NOTIFICATIONS.child(user.uid).childByAutoId().updateChildValues(values)
    }
    
    fileprivate func fetchNotifications(uid: String, completion: @escaping([Notification]) -> Void) {
        var notifications = [Notification]()

        REF_NOTIFICATIONS.child(uid).observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            
            UserService.shared.fetchUser(uid: uid) { user in
                let notification = Notification(user: user, dictionary: dictionary)
                notifications.append(notification)
                completion(notifications)
            }
        }
    }
    
    func fetchNotifications(completion: @escaping([Notification]) -> Void) {
        let notifications = [Notification]()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_NOTIFICATIONS.child(uid).observeSingleEvent(of: .value) { snapshot in
            if !snapshot.exists() {
                completion(notifications)
            } else {
                self.fetchNotifications(uid: uid, completion: completion)
            }
        }
    }
}
