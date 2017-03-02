//
//  TweetTableViewCell.swift
//  twitter-clone
//
//  Created by Rodrigo Bell on 2/18/17.
//  Copyright © 2017 Rodrigo Bell. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var tweetTimestamp: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoritesCount: UILabel!
    // User to update image displayed
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoritesButton: UIButton!
    
    var tweet: Tweet! {
        didSet {
            userImage.setImageWith((tweet.user?.profileImageURL!)!)
            userImage.layer.cornerRadius = 3
            userImage.clipsToBounds = true
            userName.text = tweet.user?.name
            userHandle.text = tweet.user?.handle
            tweetTimestamp.text = calculateTimestamp((tweet!.createdAt?.timeIntervalSinceNow)!)
            tweetText.text = tweet.tweetText
            retweetCount.text = "\(tweet.retweetCount!)"
            favoritesCount.text = "\(tweet.favoriteCount!)"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func calculateTimestamp(_ timeTweetPostedAgo: TimeInterval) -> String {
        var rawTime = Int(timeTweetPostedAgo)
        var timeAgo: Int = 0
        var timeChar = ""
        
        rawTime = rawTime * (-1)
        
        if (rawTime <= 60) { // SECONDS
            timeAgo = rawTime
            timeChar = "s"
        } else if ((rawTime/60) <= 60) { // MINUTES
            timeAgo = rawTime/60
            timeChar = "m"
        } else if (rawTime/60/60 <= 24) { // HOURS
            timeAgo = rawTime/60/60
            timeChar = "h"
        } else if (rawTime/60/60/24 <= 365) { // DAYS
            timeAgo = rawTime/60/60/24
            timeChar = "d"
        } else if (rawTime/(3153600) <= 1) { // YEARS
            timeAgo = rawTime/60/60/24/365
            timeChar = "y"
        }
        return "\(timeAgo)\(timeChar)"
    }
    
}
