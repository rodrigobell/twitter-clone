//
//  Tweet.swift
//  twitter-clone
//
//  Created by Rodrigo Bell on 2/18/17.
//  Copyright © 2017 Rodrigo Bell. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var user: User?
    var tweetTimestamp: String?
    var tweetText: String?
    var retweetCount: Int?
    var favoriteCount: Int?
    var id: Int?
    var retweeted: Bool?
    var favorited: Bool?
    
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        
        if let timestampUnformatted = dictionary["created_at"] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            let timestampDate = formatter.date(from: timestampUnformatted)
            tweetTimestamp = formatter.string(from: timestampDate!)
        }
        
        tweetText = (dictionary["text"] as? String)!
        retweetCount = dictionary["retweet_count"] as? Int ?? 0
        favoriteCount = dictionary["favorite_count"] as? Int ?? 0
        
        id = dictionary["id"] as? Int
        retweeted = dictionary["retweeted"] as? Bool
        favorited = dictionary["favorited"] as? Bool
        
    }
    
    class func tweetsWithArray(_ dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }

}
