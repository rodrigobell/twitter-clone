//
//  LoginViewController.swift
//  twitter-clone
//
//  Created by Rodrigo Bell on 2/17/17.
//  Copyright © 2017 Rodrigo Bell. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        let client = TwitterClient.sharedInstance
        
        client.login(success: { () -> () in
            print("I've logged in")
            self.performSegue(withIdentifier: "login-segue", sender: nil)
        }) { (error: Error) -> ()in
            print("error: \(error.localizedDescription)")
        }
    }

}
