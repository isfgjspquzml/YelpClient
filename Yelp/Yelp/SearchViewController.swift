//
//  ViewController.swift
//  Yelp
//
//  Created by Tianyu Shi on 9/20/14.
//  Copyright (c) 2014 Tianyu Shi. All rights reserved.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var searchResultTableView: UITableView!

    let locationManager = CLLocationManager()
    
    var client: YelpClient!
    var searchDict: NSArray?
    lazy var fileNotFound = UIImage(named: "filenotfound.png")
    
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
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        // Do any additional setup after loading the view, typically from a nib.
        client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        client.updateTerm("Thai")
        client.updateLocation("San Francisco")
        
        doSearch()
    }
    
    func doSearch() {
        client.search({(operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var errorValue: NSError? = nil
            let dictionary: Dictionary<String, AnyObject> = self.JSONParseDict(response)
            self.searchDict = dictionary["businesses"] as NSArray!
            self.searchResultTableView.reloadData()
            }, {(operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
        })
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println(locations)
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
        let businessDict = self.searchDict![indexPath.row] as NSDictionary
        
        cell.numberLabel.text = String(indexPath.row) + "."
        cell.nameLabel.text = businessDict["name"] as String!
        var location = businessDict["location"] as NSDictionary!
        var area = (location["neighborhoods"]?[0]? as? NSString ?? location["city"]! as String)
        var address = location["address"]![0]! as String
        cell.locationLabel.text = address + ", " + area
        
        let thumbnailURL = NSURL.URLWithString(businessDict["image_url"] as String)
        let thumbnailURLRequest = NSURLRequest(URL: thumbnailURL)
        let thumbnailRequest = AFHTTPRequestOperation(request: thumbnailURLRequest)
        thumbnailRequest.responseSerializer = AFImageResponseSerializer()
        thumbnailRequest.setCompletionBlockWithSuccess(
            {(operation: AFHTTPRequestOperation!, obj) in
                cell.thumbnailImageView.image = obj as? UIImage
                UIView.animateWithDuration(1, animations: {
                    cell.thumbnailImageView.alpha = 1
                })
            },
            failure: {(operation: AFHTTPRequestOperation!, obj) in
                cell.thumbnailImageView.image = self.fileNotFound
        })
        thumbnailRequest.start()
        
        cell.numberReviewsLabel.text = String(businessDict["review_count"] as Int)
        
        
        return cell
    }
    
    
}

