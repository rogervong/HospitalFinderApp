//
//  Bookmark+CoreDataProperties.swift
//  HospitalFinder
//
//  Created by Daniel Ra on 7/28/16.
//  Copyright © 2016 Daniel Ra. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Bookmark {

    @NSManaged var bookmarked: NSNumber?
    @NSManaged var date: NSDate?
    @NSManaged var id: NSNumber?
    @NSManaged var imageUrl: String?
    @NSManaged var location: String?
    @NSManaged var name: String?
    @NSManaged var phoneNumber: String?
    @NSManaged var rating: NSNumber?
    @NSManaged var website: String?

}
