//
//  LocationManager.swift
//  HospitalFinder
//
//  Created by Kevin Mueller on 7/26/16.
//  Copyright © 2016 Daniel Ra. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject,CLLocationManagerDelegate  {
    
    enum LocationManagerError:ErrorType{
        case NoLocationServiceError // This is default error
        case DeniedError
    }
    
    
    var locationManager:CLLocationManager
    var locationManagerClosures: [((userLocation: CLLocation) -> ())] = []
    
    
    override init(){
        locationManager = CLLocationManager()
        super.init()
        self.locationManager.delegate = self
    }
    
    
    func getlocationForUser(userLocationClosure: ((userLocation: CLLocation) -> ())) throws {
        
        
        
        self.locationManagerClosures.append(userLocationClosure)
        
        
        if CLLocationManager.locationServicesEnabled() {
            //Then check whether the user has granted you permission to get his location
            if CLLocationManager.authorizationStatus() == .NotDetermined {
                locationManager.requestWhenInUseAuthorization()
            } else if CLLocationManager.authorizationStatus() == .Restricted || CLLocationManager.authorizationStatus() == .Denied {
                throw LocationManagerError.DeniedError
            } else if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
                // This will trigger the locationManager:didUpdateLocation delegate method to get called when the next available location of the user is available
                locationManager.startUpdatingLocation()
            }
            else{
                throw LocationManagerError.NoLocationServiceError
            }
        }
        
    }
    
    // Delegate methods for location services
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        //Because multiple methods might have called getlocationForUser: method there might me multiple methods that need the users location.
        //These userLocation closures will have been stored in the locationManagerClosures array so now that we have the users location we can pass the users location into all of them and then reset the array.
        let tempClosures = self.locationManagerClosures
        tempClosures.map{$0(userLocation:newLocation)}
        self.locationManagerClosures = []
    }
    
    @objc func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }


}
