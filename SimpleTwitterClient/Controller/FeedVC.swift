//
//  FeedVC.swift
//  SimpleTwitterClient
//
//  Created by Mokhamad Valid Kazimi on 18.04.2018.
//  Copyright © 2018 Mokhamad Valid Kazimi. All rights reserved.
//

import UIKit
import TwitterKit

// An attempt to implement Home Timeline manually using TwitterKit.

class FeedVC: UIViewController, TWTRTweetViewDelegate {
    // Properties
    var tweets: [[TWTRTweet]] = []
    var isLoadingTweets = false
    var prototypeCell: TWTRTweetTableViewCell?
    
    // Outlets
    @IBOutlet weak var userProfileIcon: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        if TWTRTwitter.sharedInstance().sessionStore.hasLoggedInUsers() {
            configureViewWhenLoggedIn()
            loadTweets()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if TWTRTwitter.sharedInstance().sessionStore.hasLoggedInUsers() {
            configureViewWhenLoggedIn()
            loadTweets()
        }
    }
    
    // Methods
    func configureViewWhenLoggedIn() {
        let userID = TWTRTwitter.sharedInstance().sessionStore.session()?.userID
        let client = TWTRAPIClient(userID: userID)
        
        client.loadUser(withID: userID!, completion: { (user, error) in
            let imageURL = user?.profileImageURL
            let url = URL(string: imageURL!)
            let data = try? Data(contentsOf: url!)
            self.userProfileIcon.image = UIImage(data: data!)
        })
        
        prototypeCell = TWTRTweetTableViewCell(style: .default, reuseIdentifier: TWEET_CELL_REUSE_IDENTIFIER)
        tableView.register(TWTRTweetTableViewCell.self, forCellReuseIdentifier: TWEET_CELL_REUSE_IDENTIFIER)
        
    }
    
    func loadTweets() {
        if isLoadingTweets {
            return
        }
        
        isLoadingTweets = true
        
        let userID = TWTRTwitter.sharedInstance().sessionStore.session()?.userID
        let client = TWTRAPIClient(userID: userID)

        var clientError: NSError?
        let urlRequest = client.urlRequest(withMethod: "GET", urlString: "https://api.twitter.com/1.1/statuses/home_timeline.json?count=50", parameters: nil, error: &clientError)

        client.sendTwitterRequest(urlRequest) { (response, data, error) in
            if error == nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    
                    let tweets = TWTRTweet.tweets(withJSONArray: json as? [Any])
                    self.tweets.append(tweets as! [TWTRTweet])
                    self.tableView.reloadData()
                    print("json: \(json)")
                } catch let jsonError as NSError {
                    print("json error: \(jsonError.localizedDescription)")
                }
            } else {
                print("error: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    // Actions
    @IBAction func logoutBtnPressed(_ sender: Any) {
        let sessionStore = TWTRTwitter.sharedInstance().sessionStore
        if let userId = sessionStore.session()?.userID {
            sessionStore.logOutUserID(userId)
            tweets.removeAll()
            tableView.reloadData()
            
            let loginVC = storyboard?.instantiateViewController(withIdentifier: LOGIN_VC_ID)
            present(loginVC!, animated: true, completion: nil)
        }
    }
}

extension FeedVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TWEET_CELL_REUSE_IDENTIFIER, for: indexPath) as! TWTRTweetTableViewCell
        
        cell.tweetView.showActionButtons = true
        
        let tweet = tweets[indexPath.section][indexPath.row]
        cell.configure(with: tweet)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tweet = tweets[indexPath.section][indexPath.row]
        prototypeCell?.configure(with: tweet)
        
        return TWTRTweetTableViewCell.height(for: tweet, style: TWTRTweetViewStyle.compact, width: self.view.bounds.width, showingActions: true)
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row == (tweets.last?.count)! - 1 {
//            loadTweets()
//            tableView.reloadData()
//            print("!!!!!!!!!! loaded more tweets.")
//        }
//    }
}
