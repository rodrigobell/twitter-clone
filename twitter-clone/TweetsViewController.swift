//
//  TweetsViewController.swift
//  twitter-clone
//
//  Created by Rodrigo Bell on 2/17/17.
//  Copyright © 2017 Rodrigo Bell. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]? = nil
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(TweetsViewController.refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        
        getTweets()
    }

    func getTweets() {
        TwitterClient.sharedInstance.getHomeTimeline(success: { (tweets) in
            self.tweets = tweets
            self.tableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "tweet-cell", for: indexPath) as! TweetTableViewCell
        
        if tweets != nil {
            cell.tweet = tweets?[indexPath.row]
            cell.selectionStyle = .none
        }
        
        return cell
    }
    
    @IBAction func onRetweetButtonTapped(_ sender: Any) {
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview as! TweetTableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let tweet = tweets![indexPath!.row]
        let path = tweet.id
        let retweeted = tweet.retweeted
        
        if retweeted == false {
            TwitterClient.sharedInstance.retweet(id: path!, params: nil) { (error) -> () in
                print("Retweeting")
                self.tweets![indexPath!.row].retweetCount = self.tweets![indexPath!.row].retweetCount! + 1
                tweet.retweeted = true
                cell.retweetButton.setImage(UIImage(named: "retweet-action-on-green.png"), for: UIControlState())
                self.tableView.reloadData()
            }
        } else if retweeted ==  true {
            TwitterClient.sharedInstance.unretweet(id: path!, params: nil , completion: { (error) -> () in
                print("Unretweeting")
                self.tweets![indexPath!.row].retweetCount  = self.tweets![indexPath!.row].retweetCount! - 1
                tweet.retweeted = false
                cell.retweetButton.setImage(UIImage(named: "retweet-action-default.png"), for: UIControlState())
                self.tableView.reloadData()
            })
        }
    }

    @IBAction func onFavoriteButtonTapped(_ sender: Any) {
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview as! TweetTableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let tweet = tweets![indexPath!.row]
        let path = tweet.id
        let favorited = tweet.favorited
        
        if favorited == false {
            TwitterClient.sharedInstance.favorite(id: path!, params: nil) { (error) -> () in
                print("Favoriting")
                self.tweets![indexPath!.row].favoriteCount = self.tweets![indexPath!.row].favoriteCount! + 1
                tweet.favorited = true
                cell.favoritesButton.setImage(UIImage(named: "like-action-on-red.png"), for: UIControlState())
                self.tableView.reloadData()
            }
        } else if favorited ==  true {
            TwitterClient.sharedInstance.unfavorite(id: path!, params: nil , completion: { (error) -> () in
                print("Unfavoriting")
                self.tweets![indexPath!.row].favoriteCount  = self.tweets![indexPath!.row].favoriteCount! - 1
                tweet.favorited = false
                cell.favoritesButton.setImage(UIImage(named: "like-action-off.png"), for: UIControlState())
                self.tableView.reloadData()
            })
        }
    }
    
    @IBAction func onLogoutButtonTapped(_ sender: Any) {
        User.currentUser?.logout()
    }

    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance.getHomeTimeline(success: { (tweets) in
            self.tweets = tweets
            self.tableView.reloadData()
        }) { (error) in
            print(error)
        }
        refreshControl.endRefreshing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "tweet-details") {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets![indexPath!.row]
            
            let vc = segue.destination as! TweetDetailViewController
            vc.tweet = tweet
        }
    }
}
























