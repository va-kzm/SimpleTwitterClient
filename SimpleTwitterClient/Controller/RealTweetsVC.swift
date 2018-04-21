//
//  TimelineViewController.swift
//  SimpleTwitterClient
//
//  Created by Mokhamad Valid Kazimi on 19.04.2018.
//  Copyright © 2018 Mokhamad Valid Kazimi. All rights reserved.
//

import UIKit
import TwitterKit

// User's tweets feed implemented using TWTRTimelineViewController and TWTRUserTimelineDataSource.
// User timeline can be obtained by using the built in TwitterKit functionality.

class RealTweetsVC: TWTRTimelineViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userID = TWTRTwitter.sharedInstance().sessionStore.session()?.userID
        let client = TWTRAPIClient(userID: userID)
        
        client.loadUser(withID: userID!) { (user, error) in
            if user != nil {
                self.dataSource = TWTRUserTimelineDataSource(screenName: nil, userID: user?.userID, apiClient: client, maxTweetsPerRequest: 15, includeReplies: true, includeRetweets: false)
            }
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "logoutIcon"), style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Post a Tweet", style: .plain, target: self, action: #selector(composeTweet))
    }
    
    // Methods
    @objc func composeTweet() {
        if TWTRTwitter.sharedInstance().sessionStore.hasLoggedInUsers() {
            let composer = TWTRComposerViewController.emptyComposer()
            present(composer, animated: true, completion: nil)
        }
    }
    
    @objc func handleLogout() {
        let sessionStore = TWTRTwitter.sharedInstance().sessionStore
        if let userId = sessionStore.session()?.userID {
            sessionStore.logOutUserID(userId)
            
            let loginVC = storyboard?.instantiateViewController(withIdentifier: LOGIN_VC_ID)
            present(loginVC!, animated: true, completion: nil)
        }
    }
}
