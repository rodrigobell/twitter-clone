//
//  TwitterClient.swift
//  twitter-clone
//
//  Created by Rodrigo Bell on 2/18/17.
//  Copyright © 2017 Rodrigo Bell. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterBaseURL = NSURL(string: "https://api.twitter.com")
let twitterConsumerKey = "yP60Ej5ExVSFi6YaSIFsCcJva"
let twitterConsumerSecret = "cr49D7HSgHQWWhRuBhFQipbLKeSU3IN3PuUpE5FhtW3qp0Ix1a"

class TwitterClient: BDBOAuth1SessionManager {
    
    static var sharedInstance: TwitterClient {
        struct Static {
            static let instance  = TwitterClient(
                baseURL: twitterBaseURL as URL!,
                consumerKey: twitterConsumerKey,
                consumerSecret: twitterConsumerSecret
            )
        }
        return Static.instance!
    }
    
    var loginSuccess: (() ->())?
    var loginFailure: ((Error) -> ())?
    var loginCompletion: (( _ user: User?, _ error: NSError?) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        
        loginSuccess = success
        loginFailure = failure
        
        // Logout from any previous sessions before attempting to login again to prevent issues
        TwitterClient.sharedInstance.deauthorize()
        
        TwitterClient.sharedInstance.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterclone://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
            print("I got a token")
            // Open Safari with url using requestToken
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            
        }) { (error: Error?) -> Void in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        }
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) -> Void in
            print("Received access token")
            
            self.getCurrentAccount(success: { (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) -> () in
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
            })
            
            self.loginSuccess?()
            
        })  { (error: Error?) in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        }
    }
    
    func getCurrentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void  in
            print("Account: \(response)")
            let userDictionary = response as! NSDictionary
            
            let user = User(dictionary: userDictionary)
            
            success(user)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            print("error: \(error.localizedDescription)")
            failure(error)
        })
    }
    
    func getHomeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> () ) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response:Any?) -> Void in
            print("Got home timeline")
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            print("error: \(error.localizedDescription)")
            failure(error)
        })        
    }
    
    func getMoreTweetsFromHomeTimeLine(fromID: Int, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        
        get("1.1/statuses/home_timeline.json?max_id=\(fromID)", parameters: nil,
            progress: nil, success: { (task: URLSessionDataTask!, response: Any?) -> Void in
                let dictionaries = response as! [NSDictionary]
                let tweets = Tweet.tweetsWithArray(dictionaries)
                
                success(tweets)
        }, failure: { (operation: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
    }
    
    func retweet(id: Int, params: NSDictionary?, completion: @escaping (_ error: NSError?) -> () ){
        post("1.1/statuses/retweet/\(id).json", parameters: params, success: { (operation: URLSessionDataTask!, response: Any?) -> Void in
            print("Retweeted tweet with id: \(id)")
            completion(nil)
        }, failure: { (operation: URLSessionDataTask?, error: Error!) -> Void in
            print("Couldn't retweet: \(error.localizedDescription)")
            completion(error as NSError?)
        })
    }
    
    func unretweet(id: Int, params: NSDictionary?, completion: @escaping (_ error: NSError?) -> () ){
        post("1.1/statuses/unretweet/\(id).json", parameters: params, success: { (operation: URLSessionDataTask!, response: Any?) -> Void in
            print("Unretweeted tweet with id: \(id)")
            completion(nil)
        }, failure: { (operation: URLSessionDataTask?, error: Error?) -> Void in
            print("Can't unretweet")
            completion(error as NSError?)
        })
    }
    
    func favorite(id: Int, params: NSDictionary?, completion: @escaping (_ error: NSError?) -> () ){
        post("1.1/favorites/create.json?id=\(id)", parameters: params, success: { (operation: URLSessionDataTask!, response: Any?) -> Void in
            print("Liked tweet with id: \(id)")
            completion(nil)
        }, failure: { (operation: URLSessionDataTask?, error: Error?) -> Void in
            print("Couldn't like tweet")
            completion(error as NSError?)
        })
    }
    
    func unfavorite(id: Int, params: NSDictionary?, completion: @escaping (_ error: NSError?) -> () ){
        post("1.1/favorites/destroy.json?id=\(id)", parameters: params, success: { (operation: URLSessionDataTask!, response: Any?) -> Void in
            print("Unliked tweet with id: \(id)")
            completion(nil)
        }, failure: { (operation: URLSessionDataTask?, error: Error?) -> Void in
            print("Couldn't unlike tweet")
            completion(error as NSError?)
        })
    }
    
    func compose(escapedTweet: String, params: NSDictionary?, completion: @escaping (_ error: NSError?) -> () ){
        post("1.1/statuses/update.json?status=\(escapedTweet)", parameters: params, success: { (operation: URLSessionDataTask!, response: Any?) -> Void in
            print("Tweeted: \(escapedTweet)")
            completion(nil)
        }, failure: { (operation: URLSessionDataTask?, error: Error?) -> Void in
            print("Couldn't compose: \(error?.localizedDescription)")
            completion(error as NSError?)
        })
    }
    
    func reply(escapedTweet: String, statusID: Int, params: NSDictionary?, completion: @escaping (_ error: NSError?) -> () ){
        post("1.1/statuses/update.json?in_reply_to_status_id=\(statusID)&status=\(escapedTweet)", parameters: params, success: { (operation: URLSessionDataTask!, response: Any?) -> Void in
            print("Replied: \(escapedTweet)")
            completion(nil)
        }, failure: { (operation: URLSessionDataTask?, error: Error?) -> Void in
            print("Couldn't reply")
            completion(error as NSError?)
        })
    }
    
}





















