//
//  listViewController.swift
//  HospitalFinder
//
//  Created by Daniel Ra on 7/25/16.
//  Copyright © 2016 Daniel Ra. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class ListViewController: UITableViewController,UISearchResultsUpdating,UISearchBarDelegate, BookmarkButtonDelegate {
    
    var bookMark: [Bookmark] = []
    var hospitals = [Hospital]()
    var toPass: String?
    var filterModel = FilterModel()
    var textfilteredHospitals = [Hospital]()
    var filteredHospitals = [Hospital]()
    let searchController = UISearchController(searchResultsController: nil)
    var locationManager:LocationManager?
    var userLocation:CLLocation?
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorColor = UIColor(red:0.13, green:0.17, blue:0.24, alpha:1.0)
        UITabBar.appearance().barTintColor = UIColor(red:0.13, green:0.17, blue:0.24, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.locationManager = LocationManager()
        do{
            try
                self.locationManager!.getlocationForUser { (userLocation: CLLocation) -> () in
                    print(userLocation)
                    self.userLocation = userLocation
                    self.getAllHospitals()
            }
        }catch {
            self.getAllHospitals()
        }
        print(toPass!)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        self.searchController.searchBar.backgroundColor = UIColor.whiteColor()
       
        return UIStatusBarStyle.LightContent

    }
    
    override func viewWillAppear(animated: Bool) {
        let tbvc = self.tabBarController as! MainTabController
        filterModel = tbvc.filterModel
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.scopeButtonTitles = ["Rating", "Distance","ConsultingFee"]
        searchController.searchBar.delegate = self

        // dumb hack to change textField color.
        for subview in self.searchController.searchBar.subviews{
            for secondlevelView in subview.subviews{
                if secondlevelView.isKindOfClass(UITextField){
                    (secondlevelView as! UITextField).textColor = UIColor.whiteColor()
                }
            }
        }
        
        
        print(filterModel.distance)
        print(filterModel.rating)
        filteredHospitals = applyFilterModel(self.filterModel, hospitals: hospitals)
        
        tableView.reloadData()
        
        
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomCell") as! CustomCell
        let hospital:Hospital
        
        // check for active search
        if searchController.active && searchController.searchBar.text != "" {
            hospital = textfilteredHospitals[indexPath.row]
        } else {
            hospital = filteredHospitals[indexPath.row]
        }
        
        
        if let myImage = hospital.image{
            cell.hospitialImageView.image = myImage
        }
        
        cell.indexPath = indexPath
        cell.hospitalIDcell = hospital.id
        cell.delegate = self
        
        cell.nameLabel.text = "\(hospital.name)"
        cell.locationLabel.text = "\(hospital.location)"
        cell.phoneButtonLabel.setTitle(hospital.phoneNumber, forState: .Normal)
//        cell.websiteButton.setTitle(hospital.website, forState: .Normal)
        cell.ratingLabel.text = "Rating: \(hospital.rating)"
        
        // return cell so that Table View knows what to draw in each row
        return cell
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return textfilteredHospitals.count
        }
        return filteredHospitals.count
    }
    
    
    func getAllHospitals() {
        print("> getAllHospitals()")
        Hospital.getAllHospitals() {
            data, response, error in
            do {
                
                // Try converting the JSON object to "Foundation Types" (NSDictionary, NSArray, NSString, etc.)
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSArray {
                    //                    print(jsonResult.firstObject)
                    for result in jsonResult{
                        // need to put this code into a convience initalizier
                        let newHospital = Hospital()
                        newHospital.name = "\(result.valueForKey("name")!)"
                        //newHospital.name = "\(result.valueForKey("name")!)"
                        newHospital.location = "\(result.valueForKey("location")!)"
                        newHospital.latitude = (result.valueForKey("latitude") as? Double)!
                        newHospital.longitude = (result.valueForKey("longitude") as? Double)!
                        newHospital.phoneNumber = (result.valueForKey("phone") as? String)!
                        newHospital.website = (result.valueForKey("website") as? String)!
                        newHospital.descript = (result.valueForKey("description") as? String)!
                        newHospital.consultingFee =  (result.valueForKey("consultingFee") as? Double)!
                        newHospital.rating = (result.valueForKey("rating") as? Float)!
                        newHospital.imageUrl = (result.valueForKey("images")?.firstObject??.valueForKey("url")! as? String)
                        newHospital.insurance = (result.valueForKey("insurances")!) as! NSArray
                        
                        let startTime = (result.valueForKey("startTime") as? String)!
                        let startIndex1 = startTime.startIndex.advancedBy(11)
                        let endIndex1 = startTime.endIndex.advancedBy(-8)
                        let substring1 = startTime[Range(startIndex1 ..< endIndex1)]
                        newHospital.startTime = substring1
                        
                        let endTime = (result.valueForKey("endTime") as? String)!
                        let startIndex2 = endTime.startIndex.advancedBy(11)
                        let endIndex2 = endTime.endIndex.advancedBy(-8)
                        let substring2 = endTime[Range(startIndex2 ..< endIndex2)]
                        newHospital.endTime = substring2
                        
                        // do not add image if image URL does not exist
                        if let imageUrl = (result.valueForKey("images")?.firstObject??.valueForKey("url")! as? String) {
                            newHospital.image =  UIImage(data: NSData(contentsOfURL: NSURL(string:imageUrl)!)!)
                        
                        let newitem = NSEntityDescription.insertNewObjectForEntityForName("Bookmark", inManagedObjectContext: self.managedObjectContext) as! Bookmark
                        newitem.id = result.valueForKey("id") as! Int
                        newitem.name = result.valueForKey("name") as? String
                        newitem.location = result.valueForKey("location") as? String
                        newitem.phoneNumber = result.valueForKey("phone") as? String
                        newitem.rating = result.valueForKey("rating") as? Float
                        newitem.imageUrl = result.valueForKey("images")?.firstObject??.valueForKey("url")! as? String
                        newitem.website = result.valueForKey("website") as? String
                        newitem.bookmarked = 0
                        
                        do{
                            try self.managedObjectContext.save()
                        } catch {
                            print("couldn't save")
                        }
                        self.tableView.reloadData()
                        print(newitem)
                        
                    }
                        
                        if self.userLocation != nil{
                            
                            let tempLat = result.valueForKey("latitude") as! Double
                            let tempLong = result.valueForKey("longitude") as! Double
                            let tempLocation = CLLocation(latitude: tempLat, longitude: tempLong)
                            newHospital.distanceFromUser = (self.userLocation?.distanceFromLocation(tempLocation))!/1000 * 0.621371
                        }
                        
                        self.hospitals.append(newHospital)
                    }
                    
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.filteredHospitals = self.applyFilterModel(self.filterModel, hospitals: self.hospitals)
                        
                        self.tableView.reloadData()
                    })
                }
            } catch {
                print("Something went wrong")
            }
        }
    }
    
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        textfilteredHospitals = filteredHospitals.filter { hospital in
            return hospital.name.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
        
    }
    func applyFilterModel(model:FilterModel,hospitals:[Hospital]) -> [Hospital]{
        
        var outHospitals = [Hospital]()
        
        outHospitals = hospitals.filter { hospital in
            return hospital.rating > model.rating && (hospital.distanceFromUser as Double) < model.distance && (hospital.consultingFee as Double) < model.consultingFee
        }
        
        return outHospitals
        
    }
    
    
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        sortContent(searchBar.scopeButtonTitles![selectedScope])
    }
    
    func sortContent(scope: String){
        
        if searchController.active && searchController.searchBar.text != "" {
            if scope == "Distance"{
                textfilteredHospitals = textfilteredHospitals.sort{$0.distanceFromUser < $1.distanceFromUser}
            }
            else if scope == "Rating"{
                textfilteredHospitals = textfilteredHospitals.sort{$0.rating > $1.rating}
                
            }
            else if scope == "ConsultingFee"{
                textfilteredHospitals = textfilteredHospitals.sort{$0.consultingFee < $1.consultingFee}

            }
            
        }
            
        else{
            if scope == "Distance"{
                filteredHospitals = filteredHospitals.sort{$0.distanceFromUser < $1.distanceFromUser}
            }
            else if scope == "Rating"{
                filteredHospitals = filteredHospitals.sort{$0.rating > $1.rating}
                
            }
            else if scope == "ConsultingFee"{
                textfilteredHospitals = textfilteredHospitals.sort{$0.consultingFee < $1.consultingFee}
                
            }
        }
        
        self.tableView.reloadData()
        
        
        
    }
    
    
    @IBAction func websiteButtonPressed(sender: UIButton) {
        let urlFromButton = sender.currentTitle!
        UIApplication.sharedApplication().openURL(NSURL(string: urlFromButton)!)
        
    }
    @IBAction func phoneButtonPressed(sender: UIButton) {
        let numberFromButton = sender.currentTitle!
        UIApplication.sharedApplication().openURL(NSURL(string: numberFromButton)!)
    }
    func bookmarkWasPressed(cell: CustomCell, atIndexPath indexPath: NSIndexPath) {
        fetchingDB()
        bookMark[indexPath.row].bookmarked = 1
        bookMark[indexPath.row].date = NSDate()
        do{
            try self.managedObjectContext.save()
        } catch {
            print("couldn't save")
        }
        print(bookMark[indexPath.row].bookmarked)
        self.tableView.reloadData()
        print("data saved")
        
        
    }
    
    func fetchingDB() {
        let request = NSFetchRequest(entityName: "Bookmark")
        bookMark = []
        do {
            let response = try managedObjectContext.executeFetchRequest(request) as! [Bookmark]
            for item in response {
                bookMark.append(item)
            }
        } catch {
            print("cannot fetch")
        }
    }
    //// Yung's code ///
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(filteredHospitals[indexPath.row].id)
        print(filteredHospitals[indexPath.row].name)
        performSegueWithIdentifier("toDetail", sender: indexPath.row)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController as! DetailViewController
        if searchController.active && searchController.searchBar.text != "" {
            destination.receivedHospital = textfilteredHospitals[sender as! Int]
        }
        destination.receivedHospital = filteredHospitals[sender as! Int]
    }
    ///////////////////
}