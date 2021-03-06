//
//  ViewController.swift
//  Yelp
//
//  Created by Tianyu Shi on 9/20/14.
//  Copyright (c) 2014 Tianyu Shi. All rights reserved.
//

import UIKit
import CoreLocation
import Darwin

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {
    
    @IBOutlet var searchResultTableView: UITableView!

    let locationManager = CLLocationManager()
    
    var client: YelpClient!
    var prototypeCell: SearchResultCell?
    var searchDict: NSArray?
    var filterButton: UIBarButtonItem?
    var searchBar: UISearchBar?
    var viewLoaded = false
    var currentlyLoading = false
    var offSet: Int = 0
    var increasingBlue = true
    var greenValue: CGFloat = 0.0
    var refreshControl: UIRefreshControl?
    
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
        if(client.valueChanged) {
            doSearch()
            client.valueChanged(false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(!viewLoaded) {
            searchResultTableView.separatorStyle = .None
        }
        
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.lightGrayColor()
        refreshControl?.tintColor = UIColor.whiteColor()
        refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        searchResultTableView.addSubview(refreshControl!)
        
        filterButton = UIBarButtonItem(title: " Filters  ", style: UIBarButtonItemStyle.Bordered, target: self, action: "segueToFilter:")
        searchBar = UISearchBar()
        searchBar!.delegate = self
        self.navigationItem.leftBarButtonItem = filterButton
        self.navigationItem.titleView = searchBar
        
        SVProgressHUD.show()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        searchResultTableView.estimatedRowHeight = 91
        searchResultTableView.rowHeight = UITableViewAutomaticDimension
        
        // Do any additional setup after loading the view, typically from a nib.
        client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        client.updateTerm("food")
        client.updateLl("37.7833,-122.4167")
        
        doSearch()
        viewLoaded = true
    }
    
    func refresh(sender:AnyObject)
    {
        doSearch()
        
        if(refreshControl != nil) {
            let dateFormater = NSDateFormatter()
            dateFormater.setLocalizedDateFormatFromTemplate("MMM d, h:mm a")
            let title = "Updated " + dateFormater.stringFromDate(NSDate())
            let attrDict = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName)
            let attrString = NSAttributedString(string: title, attributes: attrDict)
            refreshControl!.attributedTitle = attrString
            refreshControl?.endRefreshing()
        }
    }
    
    func segueToFilter (sender: UIButton) {
        let filterView = FiltersViewController(nibName: "FiltersViewController", bundle: nil)
        filterView.client = self.client
        self.navigationController?.pushViewController(filterView, animated: true)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        client.updateTerm(searchBar.text)
        client.updateOffset(0)
        offSet = 0;
        doSearch()
        searchBar.resignFirstResponder()
        println(client.parameters)
    }
    
    @IBAction func onViewTap(sender: UITapGestureRecognizer) {
        searchBar?.resignFirstResponder()
    }
    
    func doSearch() {
        println(client.parameters)
        client.search({(operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let dictionary: Dictionary<String, AnyObject> = self.JSONParseDict(response)
            let newResults = dictionary["businesses"] as NSArray!
            
            if self.searchDict != nil && self.offSet != 0 {
                self.searchDict = self.searchDict!.arrayByAddingObjectsFromArray(newResults)
            } else {
                self.searchDict = newResults
            }
            
            println(newResults)
            self.searchResultTableView.reloadData()
            SVProgressHUD.dismiss()
            self.currentlyLoading = false
            self.searchResultTableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            }, {(operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
                SVProgressHUD.dismiss()
        })
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var latValue = locationManager.location.coordinate.latitude
        var lonValue = locationManager.location.coordinate.longitude
        client.updateLl(NSString(format: "%.3f", latValue) + "," + NSString(format: "%.3f", lonValue))
    }
    
    func getDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        let R:Double = 6371 // km
        let toRadians = 3.1415926535/180
        let φ1 = lat1 * toRadians
        var φ2 = lat2 * toRadians
        var Δφ = (lat2-lat1) * toRadians
        var Δλ = (lon2-lon1) * toRadians
        var a = sin(Δφ/2) * sin(Δφ/2) +
            cos(φ1) * cos(φ2) *
            sin(Δλ/2) * sin(Δλ/2);
        var c = 2 * atan2(sqrt(a), sqrt(1-a));
        return R * c
    }
    
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
        configureCell(cell, forRowAtIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: SearchResultCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let businessDict = self.searchDict![indexPath.row] as NSDictionary
        
        cell.nameLabel.text = String(indexPath.row + 1) + ". " + (businessDict["name"] as String!)
        cell.numberReviewsLabel.text = String(businessDict["review_count"] as Int) + " Reviews"
        
        var location = businessDict["location"] as NSDictionary!
        var area = (location["neighborhoods"]?[0]? as? NSString ?? location["city"]! as String);
        var address: NSString = "Unknown"
        
        if location["address"]!.count > 0 {
            address = location["address"]![0] as NSString
        }
        cell.locationLabel.text = address + ", " + area
        
        if(businessDict["image_url"] != nil) {
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
        } else {
            cell.thumbnailImageView.image = fileNotFound
        }
        
        let averageReviewURL = NSURL.URLWithString(businessDict["rating_img_url_large"] as String)
        var err: NSError?
        var imageData :NSData = NSData.dataWithContentsOfURL(averageReviewURL,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)
        cell.averageReviewImageView.image = UIImage(data: imageData)
        
        if businessDict["distance"] != nil {
            let metersInAMile = 1609.34
            let distanceInMeters = businessDict["distance"]!.doubleValue
            cell.distanceLabel.text = NSString(format: "%0.1f", distanceInMeters/metersInAMile) + " mi"
        } else {
            cell.distanceLabel.text = ""
        }
        
        let catagories = businessDict["categories"] as NSArray?
        var allTags: String = ""
        if catagories?.count > 0 {
            allTags += (catagories![0] as NSArray)[0] as NSString
            if catagories!.count > 1 {
                for i in 1...(catagories!.count - 1) {
                    allTags += ", "
                    allTags += (catagories![i] as NSArray)[0] as String
                }
            }
        }
        cell.tagsLabel.text = allTags
        
        // Color
//        cell.backgroundColor = UIColor(red: CGFloat((1+drand48())/1.5), green: CGFloat((1+drand48())/1.5), blue: CGFloat((1+drand48())/1.5), alpha: 0.5)
        
        cell.backgroundColor = UIColor(red: 0, green: CGFloat(greenValue), blue: 1, alpha: 0.1)
        
        if(increasingBlue) {
            greenValue += 0.2
        } else {
            greenValue -= 0.2
        }
        
        if(greenValue <= 0) {
            increasingBlue = true
        } else if(greenValue >= 1) {
            increasingBlue = false
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if(viewLoaded && !currentlyLoading) {
            let position = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height - 700 // Arbitrary refresh distance
            if (position >= contentHeight) {
                SVProgressHUD.show()
                if(searchDict?.count > 0) {
                    offSet += searchDict!.count
                }
                client.updateOffset(offSet)
                doSearch()
                currentlyLoading = true
            }
        }
    }
}

