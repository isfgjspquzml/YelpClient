//
//  ViewController.swift
//  Yelp
//
//  Created by Tianyu Shi on 9/20/14.
//  Copyright (c) 2014 Tianyu Shi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var searchResultTableView: UITableView!
    
    var client: YelpClient!
    var searchDict: NSArray?
    
    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    let yelpConsumerKey = "vxKwwcR_NMQ7WaEiQBK_CA"
    let yelpConsumerSecret = "33QCvh5bIF5jIHR5klQr7RtBDhQ"
    let yelpToken = "uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV"
    let yelpTokenSecret = "mqtKIxMIR4iBtBPZCmCLEb-Dz3Y"
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        client.searchWithTerm("Thai", success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var errorValue: NSError? = nil
            let dictionary: Dictionary<String, AnyObject> = self.JSONParseDict(response)
            self.searchDict = dictionary["businesses"] as NSArray!
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println(error)
        }
    }
    
    // From https://gist.github.com/itismadhan/6e15b0edf96bb52882c7 - modified
    func JSONParseDict(jsonObj: AnyObject) -> Dictionary<String, AnyObject> {
        var e: NSError?
        var jsonString: NSString
        
        let jsonData: NSData! = NSJSONSerialization.dataWithJSONObject(
            jsonObj,
            options: NSJSONWritingOptions(0),
            error: &e)
        
        if e != nil {
            return Dictionary<String, AnyObject>()
        } else {
            jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)
        }
        
        e = nil;
        
        var data: NSData! = jsonString.dataUsingEncoding(
            NSUTF8StringEncoding)
        var jsonObj = NSJSONSerialization.JSONObjectWithData(
            data,
            options: NSJSONReadingOptions(0),
            error: &e) as Dictionary<String, AnyObject>
        if e != nil {
            return Dictionary<String, AnyObject>()
        } else {
            return jsonObj
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchDict != nil {
            return searchDict!.count
        } else {
            return 0;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = searchResultTableView.dequeueReusableCellWithIdentifier("com.tianyu.Yelp.SearchResultCell") as SearchResultCell

        
        return UITableViewCell()
    }
    
    
}

