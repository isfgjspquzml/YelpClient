//
//  YelpClient.swift
//  Yelp
//
//  Created by Tianyu Shi on 9/20/14.
//  Copyright (c) 2014 Tianyu Shi. All rights reserved.
//

import UIKit

class YelpClient: BDBOAuth1RequestOperationManager {
    var accessToken: String!
    var accessSecret: String!
    var valueChanged = false
    var parameters = Dictionary<String, AnyObject>()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
        self.accessToken = accessToken
        self.accessSecret = accessSecret
        var baseUrl = NSURL(string: "http://api.yelp.com/v2/")
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
        
        var token = BDBOAuthToken(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }
    
    func search(success: (AFHTTPRequestOperation!, AnyObject!) -> Void, failure: (AFHTTPRequestOperation!, NSError!) -> Void) -> AFHTTPRequestOperation! {
        return self.GET("search", parameters: parameters, success: success, failure: failure)
    }
    
    func updateTerm(term: String) {
        parameters.updateValue(term, forKey: "term")
    }
    
    func updateLocation(location: String) {
        parameters.updateValue(location, forKey: "location")
    }
    
    func updateOffset(offset: Int) {
        parameters.updateValue(offset, forKey: "offset")
    }
    
    func updateLl(ll: String) {
        parameters.updateValue(ll, forKey: "ll")
    }
    
    func updateValueForKey(value: AnyObject, key: String) {
        parameters.updateValue(value, forKey: key)
    }
    
    func valueChanged(changed: Bool) {
        valueChanged = changed
    }
}


