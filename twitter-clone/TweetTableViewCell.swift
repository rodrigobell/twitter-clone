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
            userName.text = tweet.user?.name
            userHandle.text = tweet.user?.handle
            tweetTimestamp.text = tweet.tweetTimestamp!
            tweetText.text = tweet.tweetText
            retweetCount.text = "\(tweet.retweetCount!)"
            favoritesCount.text = "\(tweet.favoriteCount!)"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
