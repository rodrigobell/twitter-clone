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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        TwitterClient.sharedInstance.getHomeTimeline(success: { (tweets) in
            self.tweets = tweets
            self.tableView.reloadData()
        }) { (error) in
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        }
        
    }

    @IBAction func onFavoriteButtonTapped(_ sender: Any) {
        
    }
}
























