//
//  RealFeedVC.swift
//  SimpleTwitterClient
//
//  Created by Mokhamad Valid Kazimi on 20.04.2018.
//  Copyright © 2018 Mokhamad Valid Kazimi. All rights reserved.
//

import UIKit
import TwitterKit

// Home Feed implemented using TWTRTimelineViewController.
// Home timeline can't be obtained by using the built in TwitterKit functionality, thus needs manual implementation using Twitter's REST API.

class RealFeedVC: TWTRTimelineViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userID = TWTRTwitter.sharedInstance().sessionStore.session()?.userID
        let client = TWTRAPIClient(userID: userID)
        
        client.loadUser(withID: userID!) { (user, error) in
            if user != nil {
                self.dataSource = TWTRUserTimelineDataSource(screenName: "TheRock", apiClient: client)
            }
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "logoutIcon"), style: .plain, target: self, action: #selector(handleLogout))
    }
    
    // Methods
    @objc func handleLogout() {
        let sessionStore = TWTRTwitter.sharedInstance().sessionStore
        if let userId = sessionStore.session()?.userID {
            sessionStore.logOutUserID(userId)
            
            let loginVC = storyboard?.instantiateViewController(withIdentifier: LOGIN_VC_ID)
            present(loginVC!, animated: true, completion: nil)
        }
    }
}
