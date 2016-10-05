//
//  DetailsViewController.swift
//  HospitalFinder
//
//  Created by Yung Kim on 7/28/16.
//  Copyright © 2016 Daniel Ra. All rights reserved.
//


import UIKit
import CoreData
import MapKit

class DetailViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var insuranceLabel: UILabel!

    var receivedHospital: Hospital?
    var locationManager:LocationManager?
    var userLocation:CLLocation?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DetailViewController")
        print("Name: \(receivedHospital?.name)!")
        print("Name: \(receivedHospital?.latitude)!")

        displayData()
        displayAnnotations(receivedHospital!)
        zoomToRegion(receivedHospital!)
        self.mapView.delegate = self
        
        self.locationManager = LocationManager()
        do{
            try
                self.locationManager!.getlocationForUser { (userLocation: CLLocation) -> () in
                    print(userLocation)
                    self.userLocation = userLocation
//                    self.getAllHospitals()
            }
        }catch {
//            self.getAllHospitals()
        }

    }
    
    func displayData() {
        
        
        if let myImage = receivedHospital?.image {
            imageView.image = myImage
            nameLabel.text = receivedHospital?.name
            websiteButton.setTitle(receivedHospital?.website, forState: .Normal)
            phoneButton.setTitle(receivedHospital?.phoneNumber, forState: .Normal)
//            descriptionLabel.text = receivedHospital?.descript
            if receivedHospital!.startTime == "00:00" {
                hoursLabel.text = "24 hours"
            } else {
                hoursLabel.text = "\(receivedHospital!.startTime) - \(receivedHospital!.endTime)"
            }
            
            var ins = ""
            for insurance in receivedHospital!.insurance {
                print(insurance.valueForKey("name")!)
                ins = ins + " " + (insurance.valueForKey("name")! as! String)
            }
            insuranceLabel.text = "Insurances: \(ins)"
        }
//        if insurance = 
        

        
    }
    
    func displayAnnotations(hospital: Hospital) {
        let coor = CLLocationCoordinate2D(latitude: hospital.latitude, longitude: hospital.longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coor
        annotation.title = "\(hospital.name)"
        annotation.subtitle = "\(hospital.location)"
        self.mapView.addAnnotation(annotation)
        self.mapView.delegate = self
    }
    
    func direction(hospital: Hospital) {
        
        let test = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: hospital.latitude, longitude: hospital.longitude), addressDictionary: nil)
        
        let mapItem = MKMapItem(placemark: test)
        
        mapItem.name = hospital.location
        
        //You could also choose: MKLaunchOptionsDirectionsModeWalking
        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        
        mapItem.openInMapsWithLaunchOptions(launchOptions)
    }

    func zoomToRegion(hospital: Hospital) {
        let lat = hospital.latitude
        let long = hospital.longitude
        let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let region = MKCoordinateRegionMakeWithDistance(location, 5000.0, 7000.0)
        
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func directionButtonPressed(sender: UIButton) {
        direction(receivedHospital!)
    }
    
    @IBAction func websiteButtonPressed(sender: UIButton) {
        let urlFromButton = sender.currentTitle!
        UIApplication.sharedApplication().openURL(NSURL(string: urlFromButton)!)
    }
    
    @IBAction func phoneButtonPressed(sender: UIButton) {
//        let phoneNumberFromButton = sender.currentTitle!
//        UIApplication.sharedApplication().openURL(NSURL(string: phoneNumberFromButton)!)
    }
    
    
}

