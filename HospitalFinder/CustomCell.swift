//
//  CustomCell.swift
//  HospitalFinder
//
//  Created by Daniel Ra on 7/25/16.
//  Copyright © 2016 Daniel Ra. All rights reserved.
//

import UIKit
class CustomCell: UITableViewCell {
    
    var indexPath: NSIndexPath?
    var hospitalIDcell: Int?
    var delegate: BookmarkButtonDelegate?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var hospitialImageView: UIImageView!
    @IBOutlet weak var phoneButtonLabel: UIButton!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBAction func bookmarkButton(sender: UIButton) {
        delegate?.bookmarkWasPressed(self, atIndexPath: indexPath!)
    }
}