//
//  Hospital+CoreDataProperties.swift
//  HospitalFinder
//
//  Created by Yung Kim on 7/25/16.
//  Copyright © 2016 Daniel Ra. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Hospital {

    @NSManaged var name: String?
    @NSManaged var id: NSNumber?
   

}
