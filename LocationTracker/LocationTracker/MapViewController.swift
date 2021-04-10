//
//  MapViewController.swift
//  MAPD724_Assignment5
//
//  Created by vitalii and dmytro on 2021-04-10.
//  Copyright © 2021 Dmytro&Vitalii. All rights reserved.
//
//  Assignment 5 - Frameworks App - Part 2 - App Config and Data Persistence
//
//  Group 9
//
//  Student Name: Dmytro Andriichuk
//  Student ID:   301132978
//  Date Started: 2021/03/27
//
//  Student Name: Vitalii Pielievin
//  Student ID:   300885108
//  Date Started: 2021/03/27
//
//  Location Tracker - is an app that would let user save location of places their visit and their routes,
//  changes in their location would be conviniently shown to them in the List screen, locational changes would also
//  notify users even if the phone is locked, by means of UserNotifications.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
  @IBOutlet weak var mapView: MKMapView!
  
    override func viewDidLoad() {
      super.viewDidLoad()
      mapView.userTrackingMode = .follow
      let annotations = LocationsStorage.shared.locations.map { annotationForLocation($0) }
      mapView.addAnnotations(annotations)
      NotificationCenter.default.addObserver(self, selector: #selector(newLocationAdded(_:)), name: .locationSavedNew, object: nil)
    }
  
  @IBAction func placeLocation(_ sender: Any) {
      guard let currentLocation = mapView.userLocation.location else {
        return
    }
      LocationsStorage.shared.saveCLLocationToDisk(currentLocation)
  }
  
  func annotationForLocation(_ location: Location) -> MKAnnotation {
      let annotation = MKPointAnnotation()
      annotation.title = location.dateString
      annotation.coordinate = location.coordinates
      return annotation
  }
  
  @objc func newLocationAdded(_ notification: Notification) {
      guard let location = notification.userInfo?["location"] as? Location else {
        return
    }
    
      let annotation = annotationForLocation(location)
      mapView.addAnnotation(annotation)
  }
}

