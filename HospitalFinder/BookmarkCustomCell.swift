//
//  BookmarkCustomCell.swift
//  HospitalFinder
//
//  Created by Nghia on 7/27/16.
//  Copyright © 2016 Daniel Ra. All rights reserved.
//

import UIKit

class BookmarkCustomCell: UITableViewCell {
    
    var indexPath: NSIndexPath?
    
    @IBOutlet weak var bookmarkNameLabel: UILabel!
    @IBOutlet weak var bookmarkLocationLabel: UILabel!
    @IBOutlet weak var bookmarkImageView: UIImageView!
//    @IBOutlet weak var bookmarkRatingLabel: UILabel!
    @IBOutlet weak var bookmarkWebsiteButton: UIButton!
    @IBOutlet weak var bookmarkPhoneButton: UIButton!

}

