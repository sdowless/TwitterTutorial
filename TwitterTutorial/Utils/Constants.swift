//
//  Constants.swift
//  TwitterTutorial
//
//  Created by Stephen Dowless on 1/18/20.
//  Copyright © 2020 Stephan Dowless. All rights reserved.
//

import Firebase

let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
let REF_TWEETS = DB_REF.child("tweets")
let REF_USER_TWEETS = DB_REF.child("user-tweets")
let REF_USER_FOLLOWERS = DB_REF.child("user-followers")
let REF_USER_FOLLOWING = DB_REF.child("user-following")
let REF_TWEET_REPLIES = DB_REF.child("tweet-replies")
let REF_USER_LIKES = DB_REF.child("user-likes")
let REF_TWEET_LIKES = DB_REF.child("tweet-likes")
let REF_NOTIFICATIONS = DB_REF.child("notifications")
let REF_USER_REPLIES = DB_REF.child("user-replies")
let REF_USER_USERNAMES = DB_REF.child("user-usernames")
let REF_MESSAGES = DB_REF.child("messages")
let REF_USER_MESSAGES = DB_REF.child("user-messages")

let KEY_EMAIL = "email"
let KEY_FULLNAME = "fullname"
let KEY_USERNAME = "username"
let KEY_PROFILE_IMAGE_URL = "profileImageUrl"
let KEY_LIKES = "likes"
let KEY_RETWEET_COUNT = "retweets"
let KEY_CAPTION = "caption"
let KEY_TIMESTAMP = "timestamp"
let KEY_UID = "uid"
let KEY_TYPE = "type"
let KEY_TWEET_ID = "tweetID"
let KEY_FROM_ID = "fromID"
let KEY_TO_ID = "toID"
let KEY_MESSAGE_TEXT = "messageText"
let KEY_MESSAGE_READ = "read"
let KEY_RETWEET_USERNAME = "retweetUsername"
let KEY_BIO = "bio"
