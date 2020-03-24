//
//  MessagingService.swift
//  TwitterTutorial
//
//  Created by Stephen Dowless on 3/24/20.
//  Copyright © 2020 Stephan Dowless. All rights reserved.
//

import Firebase

struct MessagingService {
    static let shared = MessagingService()
    
    func sendMessage(_ message: String, to uid: String, completion: @escaping(DatabaseCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let timestamp = Int(NSDate().timeIntervalSince1970)
        
        let values: [String : Any] = [KEY_TO_ID: uid,
                                      KEY_FROM_ID: currentUid,
                                      KEY_TIMESTAMP: timestamp,
                                      KEY_MESSAGE_READ: false,
                                      KEY_MESSAGE_TEXT: message]
        
        let messageRef = REF_MESSAGES.childByAutoId()
        guard let messageKey = messageRef.key else { return }
        
        messageRef.updateChildValues(values) { _, _ in
            REF_USER_MESSAGES.child(currentUid).child(uid).updateChildValues([messageKey: 1])
            REF_USER_MESSAGES.child(uid).child(currentUid).updateChildValues([messageKey: 1], withCompletionBlock: completion)
        }
    }
    
    func observeMessages(forUser user: User, completion: @escaping(Result<[Message], Error>) -> Void) {
        var messages = [Message]()
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let chatPartnerId = user.uid
        
        REF_USER_MESSAGES.child(currentUid).child(chatPartnerId).observe(.childAdded) { (snapshot) in
            let messageID = snapshot.key
            
            REF_MESSAGES.child(messageID).observeSingleEvent(of: .value) { (snapshot) in
                guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
                let message = Message(dictionary: dictionary)
                messages.append(message)
                completion(.success(messages))
            }
        }
    }
    
    func fetchConversations(completion: @escaping([Conversation]) -> Void) {
        var conversations = [Conversation]()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_MESSAGES.child(uid).observe(.childAdded) { snapshot in
            let uid = snapshot.key
            guard let last = snapshot.children.allObjects.last as? DataSnapshot else { return }
            
            self.fetchMessage(messageID: last.key) { message in
                UserService.shared.fetchUser(uid: uid) { user in
                    let conversation = Conversation(user: user, message: message)
                    conversations.append(conversation)
                    completion(conversations)
                }
            }
        }
    }
    
    fileprivate func fetchMessage(messageID: String, completion: @escaping(Message) -> Void) {
        REF_MESSAGES.child(messageID).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            let message = Message(dictionary: dictionary)
            completion(message)
        }
    }
}
