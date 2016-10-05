//
//  BookmarkButtonDelegate.swift
//  HospitalFinder
//
//  Created by Nghia on 7/27/16.
//  Copyright © 2016 Daniel Ra. All rights reserved.
//

import Foundation

protocol BookmarkButtonDelegate: class {
    func bookmarkWasPressed(cell: CustomCell, atIndexPath indexPath: NSIndexPath)
}