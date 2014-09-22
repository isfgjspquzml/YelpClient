//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Tianyu Shi on 9/22/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController {

    var client: YelpClient?
    var tempDictionary: NSDictionary?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
