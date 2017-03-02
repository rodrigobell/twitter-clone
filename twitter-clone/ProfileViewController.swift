//
//  ProfileViewController.swift
//  twitter-clone
//
//  Created by Rodrigo Bell on 2/27/17.
//  Copyright © 2017 Rodrigo Bell. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var user: User?
    
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerImageView.sizeToFit()
        profileImageView.setImageWith((user?.profileImageURL)! as URL)
        headerImageView.setImageWith((user?.bannerImageURL)! as URL)
        userNameLabel.text = user?.name
        handleLabel.text = user?.handle
        followingCountLabel.text = String(describing: user!.followingCount)
        followersCountLabel.text = String(describing: user!.followerCount)
        

//        self.navigationController?.navigationBar.barTintColor = UIColor.clear

    }

//    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.navigationBar.barTintColor =  UIColor(red: 85.0/255.0, green: 172.0/255.0, blue: 253.0/255.0, alpha: 1.0)
//    }

}
