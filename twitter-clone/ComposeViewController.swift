//
//  ComposeViewController.swift
//  twitter-clone
//
//  Created by Rodrigo Bell on 2/27/17.
//  Copyright © 2017 Rodrigo Bell. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {
    
    var tweet: Tweet?
    var message: String = ""
    var isReply: Bool?

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var composeTextView: UITextView!
    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var characterCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        composeTextView.delegate = self
        composeTextView.becomeFirstResponder()
        
        profileImageView.setImageWith((User._currentUser?.profileImageURL)!)
        profileImageView.layer.cornerRadius = 3
        profileImageView.clipsToBounds = true
        tweetButton.layer.cornerRadius = 5
        
        if (isReply) == true {
            composeTextView.text = "@\((tweet?.user?.handle)!) "
            isReply = false
        }
        characterCount.text = "\(140 - composeTextView.text!.characters.count)"
    }
    
    @IBAction func onTweetButtonTapped(_ sender: Any) {
        self.message = composeTextView.text
        let escapedTweetMessage = self.message.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        if isReply == true {
            TwitterClient.sharedInstance.reply(escapedTweet: escapedTweetMessage!, statusID: tweet!.id!, params: nil , completion: { (error) -> () in })
            isReply = false
            self.dismiss(animated: true, completion: {});
        } else {
            TwitterClient.sharedInstance.compose(escapedTweet: escapedTweetMessage!, params: nil, completion: { (error) -> () in })
            self.dismiss(animated: true, completion: {});
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if  0 < (141 - composeTextView.text!.characters.count) {
            tweetButton.backgroundColor = UIColor(red: 85.0/255.0, green: 172.0/255.0, blue: 253.0/255.0, alpha: 1.0)
            tweetButton.isEnabled = true
            characterCount.textColor = UIColor.darkGray
            characterCount.text = "\(140 - composeTextView.text!.characters.count)"
        } else {
            tweetButton.backgroundColor = UIColor.lightGray
            tweetButton.isEnabled = false
            characterCount.textColor = UIColor.red
            characterCount.text = "\(140 - composeTextView.text!.characters.count)"
        }
    }
    
    
    @IBAction func didTapExit(_ sender: Any) {
        self.dismiss(animated: true, completion: {});
    }

}
