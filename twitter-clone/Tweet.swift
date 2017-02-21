//
//  Tweet.swift
//  twitter-clone
//
//  Created by Rodrigo Bell on 2/18/17.
//  Copyright © 2017 Rodrigo Bell. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var tweetTimestamp: String?
    var tweetText: String?
    
    init(dictionary: NSDictionary) {
        let timestampUnformatted = dictionary["created_at"] as? String
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        let timestampDate = formatter.date(from: timestampUnformatted!)!
        tweetTimestamp = formatter.string(from: timestampDate)
        
        tweetText = (dictionary["text"] as? String)!
        
        
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
