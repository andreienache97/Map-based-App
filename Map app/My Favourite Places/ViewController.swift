//
//  ViewController.swift
//  My Favourite Places
//
//  Created by Andrei Enache on 15/11/2018.
//  Copyright © 2018 Andrei Enache. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {


    @IBOutlet weak var map: MKMapView!
    
    var locationManager = CLLocationManager()
    
    var currentPlace = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      if currentPlace == -2
        {
        addPin()
        }
        else if currentPlace == -1
        {
            map.showsUserLocation = true
            if CLLocationManager.locationServicesEnabled() == true
            {
                if CLLocationManager.authorizationStatus() == .denied ||
                    CLLocationManager.authorizationStatus() == .restricted ||
                    CLLocationManager.authorizationStatus() == .notDetermined
                {
                    locationManager.requestWhenInUseAuthorization()
                }
                locationManager.desiredAccuracy = 1.0
                locationManager.delegate = self
                locationManager.startUpdatingLocation()
                
                
            } else
            {
                print("Please turn on the location finder")
            }
            
        //myPlace()
        }
        else
        {
        showPlace()
        }
    }
    
    
    //Mark CLLocation Delegates
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude),
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        self.map.setRegion(region, animated: true)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("Unable to detect you current location")
    }
    
    func myPlace()
    {
        let name = "Ashton Building"
        let latitude = 53.406566
        let longitude = -2.966531
        
        let span = MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        self.map.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = name
        self.map.addAnnotation(annotation)
        
        
        addPin()
    }
    
    func showPlace()
    {
        guard currentPlace != -1 else { return }
        guard places.count > currentPlace else { return }
        guard let name = places[currentPlace]["name"] else { return }
        guard let lat = places[currentPlace]["lat"] else { return }
        guard let lon = places[currentPlace]["lon"] else { return }
        guard let latitude = Double(lat) else { return }
        guard let longitude = Double(lon) else { return }
        
        let span = MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        self.map.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = name
        self.map.addAnnotation(annotation)
 
        addPin()
    }
    
    func addPin()
    {
    
        let uilpgr = UILongPressGestureRecognizer(target: self, action:
        #selector(ViewController.longpress(gestureRecognizer:)))
        uilpgr.minimumPressDuration = 2
        map.addGestureRecognizer(uilpgr)
    }
    
    @objc func longpress(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
    
            let touchPoint = gestureRecognizer.location(in: self.map)
            let newCoordinate = self.map.convert(touchPoint, toCoordinateFrom: self.map)
            print(newCoordinate)
            let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            var title = ""
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                if error != nil {
                    print(error!)
                } else {
                    if let placemark = placemarks?[0] {
                        if placemark.subThoroughfare != nil {
                            title += placemark.subThoroughfare! + " "
                        }
                        if placemark.thoroughfare != nil {
                            title += placemark.thoroughfare!
                        }
                    } }
                if title == "" {
                    title = "Added \(NSDate())"
                }
                let annotation = MKPointAnnotation()
                annotation.coordinate = newCoordinate
                annotation.title = title
                self.map.addAnnotation(annotation)
                
                
                let place = Place(context: PersistenceService.context) // create a context to store the data
                place.name = title
                place.lat = String(newCoordinate.latitude)
                place.long = String(newCoordinate.longitude)
                PersistenceService.saveContext()
          
            }) }
    }
}

