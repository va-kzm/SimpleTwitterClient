//
//  TwitterAPI.swift
//  SimpleTwitterClient
//
//  Created by Mokhamad Valid Kazimi on 23.04.2018.
//  Copyright © 2018 Mokhamad Valid Kazimi. All rights reserved.
//

import UIKit
import TwitterKit

class TwitterAPI {
    // Properties
    static let instance = TwitterAPI()
    
    let consumerKey = "X8v145loRab4Gfpq2ObyLpgBi"
    let consumerSecret = "hiudlfWFFYHinygiCuu1ZMVYoQgmemMfsUmVXiiwOO5nnmXVna"
    
    let userAuthToken = TWTRTwitter.sharedInstance().sessionStore.session()?.authToken
    let userAuthTokenSecret = TWTRTwitter.sharedInstance().sessionStore.session()?.authTokenSecret
    
    // Methods
    func getHomeTimeline(withConsumerKey key: String, consumerSecret secret: String, accessToken token: String, andAccessTokenSecret tokenSecret: String, completion: @escaping (_ success: Bool) -> ()) {
        let urlString = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let oauthNonce = String.random(length: 20)
        
        
        let authorizationValue = """
        OAuth oauth_consumer_key="\(consumerKey)",oauth_token="\(userAuthToken!)",oauth_signature_method="HMAC-SHA1",oauth_timestamp="\(timestamp)",oauth_nonce="\(oauthNonce)",oauth_version="1.0",oauth_signature="iOb%2BD4FIDbuDdkmFGcC73idgLhM%3D"
        """
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "GET"
        request.addValue(authorizationValue, forHTTPHeaderField: "Authorization")
        
        
        let dataTask = URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        print(authorizationValue)
                        print(json)
                        completion(true)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        dataTask.resume()
    }
}
