//
//  TweetDetailViewController.swift
//  twitter-clone
//
//  Created by Rodrigo Bell on 2/23/17.
//  Copyright © 2017 Rodrigo Bell. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    var tweet: Tweet?
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var tweetTimestamp: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoritesCount: UILabel!
    // User to update image displayed
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoritesButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImage.setImageWith((tweet?.user?.profileImageURL)!)
        userName.text = tweet?.user?.name!
        userHandle.text = tweet?.user?.handle!
        tweetText.text = tweet?.tweetText!
        tweetTimestamp.text = tweet?.tweetTimestamp!
        retweetCount.text = "\(tweet?.retweetCount!)"
        favoritesCount.text = "\(tweet?.favoriteCount!)"

        // Do any additional setup after loading the view.
    }

}
