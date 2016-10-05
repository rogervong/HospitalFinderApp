//
//  FilterModel.swift
//  HospitalFinder
//
//  Created by Kevin Mueller on 7/26/16.
//  Copyright © 2016 Daniel Ra. All rights reserved.
//

import Foundation
import GLKit

class FilterModel: NSObject {
    
    var distance:Double
    var rating:Float
    var consultingFee:Double


    
    override init(){
        distance = 100000
        rating = 0.00
        consultingFee = 100000
    }
    


}
