//
//  ChooseCityViewController.swift
//  HospitalFinder
//
//  Created by Daniel Ra on 7/25/16.
//  Copyright © 2016 Daniel Ra. All rights reserved.
//

import UIKit

class ChooseCityViewController: UIViewController {
    
    @IBOutlet weak var bellevueButton: UIButton!
    @IBOutlet weak var seattleButton: UIButton!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var goButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        goButton.hidden = true
        cityNameLabel.hidden = true
    }
    override func  preferredStatusBarStyle()-> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let tabBarC : UITabBarController = segue.destinationViewController as! MainTabController
        let desView: ListViewController = tabBarC.viewControllers?.first as! ListViewController
        
        if (segue.identifier == "toTabBar") {
            if goButton.tag == 1 {
                print("> Bellevue")
                desView.toPass = bellevueButton.currentTitle
            } else if goButton.tag == 2 {
                print("> Seattle")
                desView.toPass = seattleButton.currentTitle
            }
        }
    }
    @IBAction func bellevueButtonPressed(sender: UIButton) {
        cityNameLabel.hidden = false
        cityNameLabel.text = "Bellevue Selected"
        goButton.tag = 1
        print(goButton.tag)
        goButton.hidden = false
    }
    @IBAction func seattleButtonPressed(sender: UIButton) {
        cityNameLabel.text = "Seattle Selected"
        goButton.tag = 2
        cityNameLabel.hidden = false
        print(goButton.tag)
        goButton.hidden = false
    }
    
    
}