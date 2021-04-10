//
//  AppDelegate.swift
//  MAPD724_Assignment5
//
//  Created by vitalii and dmytro on 2021-03-27.
//  Copyright © 2021 Dmytro&Vitalii. All rights reserved.
//
//  Assignment 4 - Frameworks App - Part 1 - Create the App UI
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
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  static let geoCoder = CLGeocoder()
  let center = UNUserNotificationCenter.current()
  let locManager = CLLocationManager()
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    
    let colorScheme = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1.0)
    UITabBar.appearance().tintColor = colorScheme
    center.requestAuthorization(options: [.alert, .sound]) { granted, error in
    }
    locManager.requestAlwaysAuthorization()
    locManager.startMonitoringVisits()
    locManager.delegate = self
    
   // Get locational updates if there are changes
   locManager.distanceFilter = 35
   // Location will be trackable in background
   locManager.allowsBackgroundLocationUpdates = true
   // Starting look out for location updates
   locManager.startUpdatingLocation()
    
    return true
    }
}

extension AppDelegate: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
    
    // create CLLocation from the coordinates of CLVisit
    let clLocation = CLLocation(latitude: visit.coordinate.latitude, longitude: visit.coordinate.longitude)
    // Location description
    AppDelegate.geoCoder.reverseGeocodeLocation(clLocation) { placemarks, _ in
      if let route = placemarks?.first {
        let description = "\(route)"
        self.gotNewLocation(visit, description: description)
            }
        }
    }
  
  func gotNewLocation(_ visit: CLVisit, description: String) {
    let location = Location(visit: visit, descriptionString: description)
    LocationsStorage.shared.saveLocationJsonData(location)
    
    let notifContent = UNMutableNotificationContent()
    notifContent.title = "New Location Tracked 📌"
    notifContent.body = location.description
    notifContent.sound = UNNotificationSound.default
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
    let request = UNNotificationRequest(identifier: location.dateString, content: notifContent, trigger: trigger)
    
    center.add(request, withCompletionHandler: nil)
    }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else {
      return
    }
    
    AppDelegate.geoCoder.reverseGeocodeLocation(location) { placemarks, _ in
      if let place = placemarks?.first {
        let description = "Fake location: \(place)"
        
        let fakeVisit = ImaginaryRoute(coordinates: location.coordinate, arrivalDate: Date(), departureDate: Date())
        self.gotNewLocation(fakeVisit, description: description)
                }
            }
        }
    }

        final class ImaginaryRoute: CLVisit {
        private let myCoordinates: CLLocationCoordinate2D
        private let myArrivalDate: Date
        private let myDepartureDate: Date

        override var coordinate: CLLocationCoordinate2D {
            return myCoordinates
        }
  
        override var arrivalDate: Date {
            return myArrivalDate
        }
  
        override var departureDate: Date {
            return myDepartureDate
        }
  
        init(coordinates: CLLocationCoordinate2D, arrivalDate: Date, departureDate: Date) {
            myCoordinates = coordinates
            myArrivalDate = arrivalDate
            myDepartureDate = departureDate
            super.init()
        }
  
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) not implemented")
            }
        }

