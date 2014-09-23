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
    var tempDictionary: Dictionary<String, AnyObject>?
    var tempCatagoriesDict: Dictionary<String, AnyObject>?
    
    var expanded = [false, false, false, false]
    var distArray: NSArray = [1, 2, 5, 10]
    var sortMethodArray: NSArray = ["Best", "Distance", "Average Review"]
    var catagoryArray: NSArray = ["Active Life", "Arts & Entertainment", "Hotels & Travel", "See All"]
    var catagoryArrayValue: NSArray = ["active", "arts", "hotelstravel", ""]
    var catagoryArrayAll: NSArray = ["Active Life", "Arts & Entertainment", "Hotels & Travel", "Local Flavor", "Nightlife"]
    var catagoryArrayAllValue: NSArray = ["active", "arts", "hotelstravel", "localflavor", "nightlife"]
    
    // THIS CODE IS EMBARASSINGLY UGLY :( BUT IT'S DUE AT 10 PM SO....
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        filterTableView.estimatedRowHeight = 80
        filterTableView.rowHeight = UITableViewAutomaticDimension
        
        tempDictionary = Dictionary<String, AnyObject>()
        tempCatagoriesDict = Dictionary<String, AnyObject>()
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
            if(expanded[0]) {
                return distArray.count+1
            }
            return 1
        case 1: // SortBy
            if(expanded[1]) {
                return sortMethodArray.count+1
            }
            return 1
        case 2: // Deals
            return 1
        case 3: // Catagories
            if(expanded[3]) {
                return catagoryArrayAll.count
            }
            return catagoryArray.count
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0: // Distance
            if(indexPath.row == 0) {
                expanded[0] = true
                filterTableView.reloadData()
            } else {
//                tempDictionary
            }
        case 1: // SortBy
            if(indexPath.row == 0) {
                expanded[1] = true
                filterTableView.reloadData()
            }
        case 3: // Catagories
            if(indexPath.row == 3 && !expanded[3]) {
                expanded[3] = true
                filterTableView.reloadData()
            }
        default:
            break
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var toggleSwitch: UISwitch = UISwitch()
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        cell.textLabel!.textColor = UIColor(red: 0, green: 0.81, blue: 1, alpha: 1)
       
        if(indexPath.section == 0 || indexPath.section == 1) {
            if(indexPath.row == 0) {
                cell.textLabel!.font = UIFont(name: "Avenir Next", size: 12)
            } else {
                cell.textLabel!.font = UIFont(name: "Avenir Next", size: 11)
            }
            cell.textLabel!.textAlignment = NSTextAlignment.Right
        } else {
            cell.textLabel!.font = UIFont(name: "Avenir Next", size: 12)
            cell.textLabel!.textAlignment = NSTextAlignment.Left
            toggleSwitch = UISwitch(frame: CGRect(x: 265, y: 6, width: 0, height: 0))
            toggleSwitch.addTarget(self, action: "updateDict:", forControlEvents: UIControlEvents.ValueChanged)
            toggleSwitch.tag = indexPath.section * 10 + indexPath.row
            cell.addSubview(toggleSwitch)
        }
        
        switch indexPath.section {
        case 0:
            if(expanded[indexPath.section] && indexPath.row != 0) {
                cell.textLabel!.text = String(distArray[indexPath.row - 1] as Int) + " mi"
            } else {
                cell.textLabel!.text = "Select Distance"
            }
        case 1:
            if(expanded[indexPath.section] && indexPath.row != 0) {
                cell.textLabel!.text = sortMethodArray[indexPath.row - 1] as NSString
            } else {
                cell.textLabel!.text = "Select Sorting Method"
            }
        case 2:
            cell.textLabel!.text = "Search For Deals"
        case 3:
            if(expanded[indexPath.section]) {
                cell.textLabel!.text = catagoryArrayAll[indexPath.row] as NSString
            } else {
                cell.textLabel!.text = catagoryArray[indexPath.row] as NSString
            }
            
            if(!expanded[3] && indexPath.row == 3) {
                toggleSwitch.removeFromSuperview()
            }
        default:
            break
        }
        
        return cell
    }
    
    func updateDict(sender: UISwitch) {
        let row = sender.tag % 10
        let section = (sender.tag - row)/10
        println(row)
        println(section)
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
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
