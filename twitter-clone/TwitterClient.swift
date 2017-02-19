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
        
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "cptwitterdemodustyn://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
            print("I got a token")
            
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            
        }) { (error: Error?) -> Void in
            self.loginFailure?(error!)
            print("Error: \(error?.localizedDescription)")
        }
    }
    
    func openURL(url: NSURL) {
        fetchAccessToken(withPath: "oauth/access_token",
                         method: "POST",
                         requestToken: BDBOAuth1Credential(queryString: url.query),
                         success: { (accessToken: BDBOAuth1Credential?) -> Void in
                            print("Got accessToken")
                            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                            
                            TwitterClient.sharedInstance.get("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: URLSessionDataTask!, response: Any?) -> Void in
                                let user = User(dictionary: response as! NSDictionary)
                                User.currentUser = user
                                
                                print("User: \(user.name)")
                                self.loginCompletion!(user, nil)
                            }, failure: { (operation: URLSessionDataTask?, error: Error) -> Void in
                                print("error getting current user")
                                self.loginCompletion!(nil, error as NSError?)
                            })
                            
        }) {
            (error: Error?) -> Void in
            print("Failed to get accessToken")
            self.loginCompletion!(nil, error as NSError?)
        }
        
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        let twitterClient = BDBOAuth1SessionManager(baseURL: URL(string:"https://api.twitter.com"), consumerKey: "NKC7pDwQIIWlo5DhTgYcQnHEq", consumerSecret: "MIxuf9GX6z8RFZWy92vvy1tPcV2nX5gA1QKypHqe5OESrHWVuf")
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) -> Void in
            print("Received access token")
            
            self.currentAccount(success: { (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) -> () in
                self.loginFailure?(error)
            })
            
            self.loginSuccess?()
            
        })  { (error: Error?) in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        }
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void  in
            print("Account: \(response)")
            let userDictionary = response as! NSDictionary
            
            let user = User(dictionary: userDictionary)
            
            success(user)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            print("Error: \(error.localizedDescription)")
            failure(error)
        })
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> () ) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response:Any?) -> Void in
            
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
        
        
    }
    
}


