//
//  TweetsVC.swift
//  SimpleTwitterClient
//
//  Created by Mokhamad Valid Kazimi on 18.04.2018.
//  Copyright © 2018 Mokhamad Valid Kazimi. All rights reserved.
//

import UIKit
import TwitterKit

// An attempt to implement User Timeline manually using TwitterKit.
// Not completed.

class TweetsVC: UIViewController {
    // Outlets
    @IBOutlet weak var userProfileIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if TWTRTwitter.sharedInstance().sessionStore.hasLoggedInUsers() {
            configureProfileView()
        }
    }
    
    // Methods
    func configureProfileView() {
        let client = TWTRAPIClient()
        let userID = TWTRTwitter.sharedInstance().sessionStore.session()?.userID
        
        client.loadUser(withID: userID!, completion: { (user, error) in
            let imageURL = user?.profileImageURL
            let url = URL(string: imageURL!)
            let data = try? Data(contentsOf: url!)
            self.userProfileIcon.image = UIImage(data: data!)
        })
    }
    
    // Actions
    @IBAction func logoutBtnPressed(_ sender: Any) {
        let sessionStore = TWTRTwitter.sharedInstance().sessionStore
        if let userId = sessionStore.session()?.userID {
            sessionStore.logOutUserID(userId)
            
            let loginVC = storyboard?.instantiateViewController(withIdentifier: LOGIN_VC_ID)
            present(loginVC!, animated: true, completion: nil)
        }
        
        // After logout the login screen must be shown and user data cleared
    }
}
