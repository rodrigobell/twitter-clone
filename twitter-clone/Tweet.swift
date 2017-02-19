//
//  Tweet.swift
//  twitter-clone
//
//  Created by Rodrigo Bell on 2/18/17.
//  Copyright © 2017 Rodrigo Bell. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var tweetText: String?
    
    init(dictionary: NSDictionary) {
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
