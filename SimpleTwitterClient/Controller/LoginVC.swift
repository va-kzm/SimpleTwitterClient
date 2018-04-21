//
//  LoginVC.swift
//  SimpleTwitterClient
//
//  Created by Mokhamad Valid Kazimi on 18.04.2018.
//  Copyright © 2018 Mokhamad Valid Kazimi. All rights reserved.
//

import UIKit
import TwitterKit

// Log in with Twitter, using TWTRLogInButton.

class LoginVC: UIViewController {
    // Properties
    var loginBtn: TWTRLogInButton!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    // Methods
    func configureView() {
        loginBtn = TWTRLogInButton { (session, error) in
            if session != nil {
                self.dismiss(animated: true, completion: nil)
            } else {
                print("error: \(String(describing: error?.localizedDescription))")
            }
        }
        
        loginBtn.center = self.view.center
        view.addSubview(loginBtn)
    }
}
