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
    
    var expanded = [false, false, false, false]
    var distArray: NSArray = [1, 2, 5, 10]
    var sortMethodArray: NSArray = ["Best", "Distance", "Average Review"]
    var catagoryArray: NSArray = ["Active Life", "Arts & Entertainment", "Hotels & Travel", "See All"]
    var catagoryArrayValue: NSArray = ["active", "arts", "hotelstravel", ""]
    var catagoryArrayAll: NSArray = ["Active Life", "Arts & Entertainment", "Hotels & Travel", "Local Flavor", "Nightlife"]
    var catagoryArrayAllValue: NSArray = ["active", "arts", "hotelstravel", "localflavor", "nightlife"]
    
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
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        cell.textLabel!.textColor = UIColor(red: 0, green: 0.81, blue: 1, alpha: 1)
        if(indexPath.row == 0) {
            cell.textLabel!.font = UIFont(name: "Avenir Next", size: 12)
        }
        
        switch indexPath.section {
        case 0:
            if(expanded[indexPath.section] && indexPath.row != 0) {
                cell.textLabel!.text = String(distArray[indexPath.row - 1] as Int) + " mi"
            } else {
                cell.textLabel!.text = "Select Distance!"
            }

            return cell
        case 1:
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)

//            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//            NSString *displaySortMethod = self.settings.sortMethod;
//            if ([self sectionIsExpanded:indexPath.section]) {
//                displaySortMethod = [self sortMethodStringArray][indexPath.row];
//            }
//            cell.textLabel.text = displaySortMethod;
            return cell;
        case 2:
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)

//            YPSwitchTableViewCell *switchCell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell" forIndexPath:indexPath];
//            switchCell.switchControl.onTintColor = [UIColor redColor];
//            switchCell.switchControl.on = self.settings.deals;
//            [switchCell.switchControl addTarget:self action:@selector(setDeals:) forControlEvents:UIControlEventValueChanged];
//            switchCell.switchLabel.text = @"Has Deal";
//            return switchCell;
            return cell
        case 3:
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)

//            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//            if ([self sectionIsExpanded:indexPath.section] || indexPath.row < 3) {
//                cell.textLabel.text = [self.categories allKeys][indexPath.row];
//            } else {
//                cell.textLabel.text = @"More...";
//            }
            return cell;
        default:
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
            return cell
        }
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
