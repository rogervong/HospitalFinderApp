//
//  filterViewController.swift
//  HospitalFinder
//
//  Created by Daniel Ra on 7/25/16.
//  Copyright © 2016 Daniel Ra. All rights reserved.
//


import UIKit
import CoreLocation

class FilterViewController: UITableViewController {
    
    @IBOutlet weak var consultingFeeSlider: UISlider!
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var ratingSlider: UISlider!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a
        tableView.separatorColor = UIColor(red:0.13, green:0.17, blue:0.24, alpha:1.0)
        distanceSlider.minimumValue = 0
        distanceSlider.maximumValue = 20
        ratingSlider.minimumValue = 0
        ratingSlider.maximumValue = 5
        consultingFeeSlider.minimumValue = 0
        consultingFeeSlider.maximumValue = 250
        
        

        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        

    }
    @IBAction func consultingFeeChanged(sender: UISlider) {
        let tbvc = self.tabBarController as! MainTabController
        tbvc.filterModel.consultingFee = Double(consultingFeeSlider.value)
    }
   
    @IBAction func ratingSliderChanged(sender: UISlider) {
        let tbvc = self.tabBarController as! MainTabController
        tbvc.filterModel.rating = ratingSlider.value
        
    }
    @IBAction func distanceSliderChanged(sender: UISlider) {
        let tbvc = self.tabBarController as! MainTabController
        tbvc.filterModel.distance = Double(distanceSlider.value)
    }
    
    override func viewWillDisappear(animated: Bool) {
       
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
       
    
}