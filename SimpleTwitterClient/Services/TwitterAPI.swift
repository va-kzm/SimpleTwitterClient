//
//  TwitterAPI.swift
//  SimpleTwitterClient
//
//  Created by Mokhamad Valid Kazimi on 23.04.2018.
//  Copyright © 2018 Mokhamad Valid Kazimi. All rights reserved.
//

import UIKit
import TwitterKit
import OhhAuth

class TwitterAPI {
    // Properties
    static let instance = TwitterAPI()
    private let authConfig = TWTRTwitter.sharedInstance().authConfig
    private let userAuthToken = TWTRTwitter.sharedInstance().sessionStore.session()?.authToken
    private let userAuthTokenSecret = TWTRTwitter.sharedInstance().sessionStore.session()?.authTokenSecret
    
    // Methods
    func getHomeTimeline(completion: @escaping (_ success: Bool) -> ()) {
        let urlString = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let oauthNonce = String.random(length: 32)
        
        let consumerKey = authConfig.consumerKey
        let consumerSecret = authConfig.consumerSecret
        
        let cc = (key: consumerKey, secret: consumerSecret)
        let uc = (key: userAuthToken!, secret: userAuthTokenSecret!)
        
        let signature = OhhAuth.calculateSignature(url: URL(string: urlString)!, method: "GET", parameter: [:], consumerCredentials: cc, userCredentials: uc)
        
//        var authorizationHeaderValue = "OAuth "
//        authorizationHeaderValue += prepareKeyValuePairForHeader(usingKey: "oauth_consumer_key", andValue: consumerKey, isLastPair: false)
//        authorizationHeaderValue += prepareKeyValuePairForHeader(usingKey: "oauth_token", andValue: userAuthToken!, isLastPair: false)
//        authorizationHeaderValue += prepareKeyValuePairForHeader(usingKey: "oauth_signature_method", andValue: "HMAC-SHA1", isLastPair: false)
//        authorizationHeaderValue += prepareKeyValuePairForHeader(usingKey: "oauth_timestamp", andValue: "\(timestamp)", isLastPair: false)
//        authorizationHeaderValue += prepareKeyValuePairForHeader(usingKey: "oauth_nonce", andValue: oauthNonce, isLastPair: false)
//        authorizationHeaderValue += prepareKeyValuePairForHeader(usingKey: "oauth_version", andValue: "1.0", isLastPair: false)
//        authorizationHeaderValue += prepareKeyValuePairForHeader(usingKey: "oauth_signature", andValue: signature, isLastPair: true)
        
        print("!!!! This is signature: \(signature)")
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "Authorization": "OAuth oauth_consumer_key=\"\(consumerKey)\", oauth_token=\"\(userAuthToken!)\", oauth_signature_method=\"HMAC-SHA1\", oauth_timestamp=\"\(timestamp)\", oauth_nonce=\"\(oauthNonce)\", oauth_version=\"1.0\", oauth_signature=\"\(signature)\""
        ]
        
//        if let session = TWTRTwitter.sharedInstance().sessionStore.session() as? TWTRSession {
//            let headerSigner = TWTROAuthSigning(authConfig: TWTRTwitter.sharedInstance().authConfig, authSession: session)
//            
//        }
        
        //request.oAuthSign(method: "GET", urlFormParameters: [:], consumerCredentials: cc, userCredentials: uc)
        
        //print("!!!!!!!!!! Authorudqdwdqd \(authorizationHeaderValue)")
        print("!!!!!!!!!! Signature: \(signature)")
        print("!!!!!!!!!! Header: \(String(describing: request.allHTTPHeaderFields))")
        
        let dataTask = URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        
                        //print("!!!!!!!!!! Authorization Header: \(authorizationHeaderValue)")
                        
                        print(json)
                        completion(true)
                    }
                } catch {
                    print("!!!!! Data Task error: \(error.localizedDescription)")
                }
            }
        }
        dataTask.resume()
    }
    
    func getHomeTimelineUsingOhhAuth(completion: @escaping (_ success: Bool) -> ()) {
        let consumerKey = authConfig.consumerKey
        let consumerSecret = authConfig.consumerSecret
        
        let cc = (key: consumerKey, secret: consumerSecret)
        let uc = (key: userAuthToken!, secret: userAuthTokenSecret!)
        
        var request = URLRequest(url: URL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")!)
        
        //let paras = ["status": "Hey Twitter! \u{1F6A7} Take a look at this sweet UUID: \(UUID())"]
        
        request.oAuthSign(method: "Get", urlFormParameters: [:], consumerCredentials: cc, userCredentials: uc)
        
        print("!!!!!!! Header: \(String(describing: request.allHTTPHeaderFields))")
        
        let task = URLSession(configuration: .ephemeral).dataTask(with: request) { (data, response, error) in
            
            if error == nil {
                if let data = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            print("!!!! This is json: \(json)")
                            completion(true)
                        }
                    } catch {
                        debugPrint(error.localizedDescription)
                    }
                }
            }
        }
        task.resume()
    }
    
    func prepareKeyValuePairForHeader(usingKey key: String, andValue value: String, isLastPair: Bool) -> String {
        var str = key.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        str += "="
        str += "\""
        str += value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        str += "\""
        
        if !isLastPair {
            str += ","
            str += " "
        }
        print("!!!!!!!! str: \(str)")
        return str
    }
}
