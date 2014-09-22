//
//  NavViewController.swift
//  Yelp
//
//  Created by Tianyu Shi on 9/21/14.
//  Copyright (c) 2014 Tianyu Shi. All rights reserved.
//

import UIKit

class NavViewController: UINavigationController {

    @IBOutlet var navBar: UINavigationBar!
    
    override func viewWillAppear(animated: Bool) {
        navBar.barTintColor = UIColor(red: 0, green: 0.81, blue: 1, alpha: 1)
        navBar.tintColor = UIColor.whiteColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
