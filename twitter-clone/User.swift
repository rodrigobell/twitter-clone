//
//  User.swift
//  twitter-clone
//
//  Created by Rodrigo Bell on 2/18/17.
//  Copyright © 2017 Rodrigo Bell. All rights reserved.
//

import UIKit

let currentUserKey = "currentUserKey"

class User: NSObject {
    var name: String?
    var handle: String?
    var profileImageURL: URL?
    var tagLine: String?
    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        handle = dictionary["screen_name"] as? String
        tagLine = dictionary["description"] as? String
        
        let profileImageString = dictionary["profile_image_url"] as? String
        if profileImageString != nil {
            profileImageURL = URL(string: profileImageString!)
        }
    }
    
    static let userDidLogoutNotification = "UserDidLogout"
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: currentUserKey) as? Data
                
                if let userData = userData{
                    
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: .allowFragments)
                    
                    _currentUser = User(dictionary: dictionary as! NSDictionary)
                }
            }
            
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary, options: [])
                defaults.set(data, forKey: currentUserKey)
            } else {
                defaults.set(nil, forKey: currentUserKey)
            }
            defaults.synchronize()
        }
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        NotificationCenter.default.post(name: Notification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }
}
