//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Tianyu Shi on 9/22/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var filterTableView: UITableView!
    
    var client: YelpClient?
    var tempDictionary: NSDictionary?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        filterTableView.estimatedRowHeight = 80
        filterTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: // Distance
            return "Distance"
        case 1: // SortBy
            return "Sorting Method"
        case 2: // Deals
            return "Deals"
        case 3: // Catagories
            return "Catagories"
        default:
            return ""
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: // Distance
            return 1
        case 1: // SortBy
            return 1
        case 2: // Deals
            return 1
        case 3: // Catagories
            return 4
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        
        return cell
    }
        
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        tempDictionary = NSDictionary()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.title = "Filters"
        let searchButton = UIBarButtonItem(title: "Search!", style: UIBarButtonItemStyle.Bordered, target: self, action: "search:")
        self.navigationItem.rightBarButtonItem = searchButton
    }
    
    func search(sender: UIBarButtonItem) {
        if(tempDictionary?.count > 0) {
            for (key, value) in tempDictionary! {
                client!.updateValueForKey(value, key: key as String)
            }
            client!.valueChanged = true
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
}
