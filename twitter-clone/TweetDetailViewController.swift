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
        userImage.layer.cornerRadius = 3
        userImage.clipsToBounds = true
        userName.text = tweet?.user?.name!
        userHandle.text = tweet?.user?.handle!
        tweetText.text = tweet?.tweetText!
        tweetTimestamp.text = calculateTimestamp((tweet!.createdAt?.timeIntervalSinceNow)!)
        retweetCount.text = "\(tweet!.retweetCount!)"
        favoritesCount.text = "\(tweet!.favoriteCount!)"

        // Do any additional setup after loading the view.
    }

    @IBAction func onRetweetButtonTapped(_ sender: Any) {
        let path = tweet!.id
        let retweeted = tweet!.retweeted
        
        if retweeted == false {
            TwitterClient.sharedInstance.retweet(id: path!, params: nil) { (error) -> () in
                print("Retweeting")
                self.tweet!.retweetCount = self.tweet!.retweetCount! + 1
                self.tweet!.retweeted = true
                self.retweetButton.setImage(UIImage(named: "retweet-action-on-green.png"), for: UIControlState())
                self.viewDidLoad()
            }
        } else if retweeted ==  true {
            TwitterClient.sharedInstance.unretweet(id: path!, params: nil , completion: { (error) -> () in
                print("Unretweeting")
                self.tweet!.retweetCount  = self.tweet!.retweetCount! - 1
                self.tweet!.retweeted = false
                self.retweetButton.setImage(UIImage(named: "retweet-action-default.png"), for: UIControlState())
                self.viewDidLoad()
            })
        }
    }
    
    @IBAction func onFavoriteButtonTapped(_ sender: Any) {
        let path = tweet!.id
        let favorited = tweet!.favorited
        
        if favorited == false {
            TwitterClient.sharedInstance.favorite(id: path!, params: nil) { (error) -> () in
                print("Favoriting")
                self.tweet!.favoriteCount = self.tweet!.favoriteCount! + 1
                self.tweet!.favorited = true
                self.favoritesButton.setImage(UIImage(named: "like-action-on-red.png"), for: UIControlState())
                self.viewDidLoad()
            }
        } else if favorited ==  true {
            TwitterClient.sharedInstance.favorite(id: path!, params: nil , completion: { (error) -> () in
                print("Unfavoriting")
                self.tweet!.favoriteCount  = self.tweet!.favoriteCount! - 1
                self.tweet!.favorited = false
                self.favoritesButton.setImage(UIImage(named: "like-action-off.png"), for: UIControlState())
                self.viewDidLoad()
            })
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier) == "segue-to-reply" {
            let vc = segue.destination as! ComposeViewController
            vc.tweet = self.tweet
            vc.isReply = true
        } else if (segue.identifier == "user-profile-segue") {
            let vc = segue.destination as! ProfileViewController
            vc.user = self.tweet?.user
        }
    }
}
