//
//  bookmarkViewController.swift
//  HospitalFinder
//
//  Created by Daniel Ra on 7/25/16.
//  Copyright © 2016 Daniel Ra. All rights reserved.
//

import UIKit
import CoreData


class BookmarkViewController: UITableViewController {
    
    
    
    
    var bookmarked: [Bookmark] = []
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var indexToDelete: Int?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        fetchFinishedObjectDB()
        //        getAllHospitals1()
        tableView.reloadData()
        //        sortBookmarks()
        //
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BookmarkCell") as! BookmarkCustomCell
        
        let bookHospital = bookmarked[indexPath.row]

        print(bookHospital.name)
        print(bookHospital.bookmarked)
        let imageUrl = bookHospital.imageUrl
        let myImage =  UIImage(data: NSData(contentsOfURL: NSURL(string:imageUrl!)!)!)
        
        cell.bookmarkNameLabel.text = String(bookHospital.name!)
        cell.bookmarkLocationLabel.text = "\(bookHospital.location!)"
        cell.bookmarkPhoneButton.setTitle(bookHospital.phoneNumber, forState: .Normal)
        cell.bookmarkWebsiteButton.setTitle(bookHospital.website!, forState: .Normal)
//        cell.bookmarkRatingLabel.text = "Rating: \(bookHospital.rating!)"
        cell.bookmarkImageView.image = myImage
        return cell
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return bookmarked.count
    }
    func fetchFinishedObjectDB() -> [Bookmark] {
        let request = NSFetchRequest(entityName: "Bookmark")
        bookmarked = []
        do {
            let response = try managedObjectContext.executeFetchRequest(request) as! [Bookmark]
            
            
            for item in response {
                if item.bookmarked == 1{
                    bookmarked.append(item)
                    print(item)
                }
                
            }
            return bookmarked
        } catch {
            print("cannot fetch")
        }
        return []
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let item = bookmarked[indexPath.row]
        print(item.name)
        item.bookmarked = 0
        do {
            try managedObjectContext.save()
        } catch {
            print("cannot remove")
        }
        fetchFinishedObjectDB()
        tableView.reloadData()
    }
}
