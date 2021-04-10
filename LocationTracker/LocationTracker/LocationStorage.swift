//
//  LocationStorage.swift
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
import CoreLocation
import UserNotifications

class LocationsStorage {
  static let shared = LocationsStorage()
  private(set) var locations: [Location]
  private let fileManager: FileManager
  private let documentsURL: URL
  
    init() {
        let fileManager = FileManager.default
        documentsURL = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        self.fileManager = fileManager
    
        let jsonDecoder = JSONDecoder()
    
        let locationFilesURLs = try! fileManager.contentsOfDirectory(at: documentsURL,
                                                                 includingPropertiesForKeys: nil)
        locations = locationFilesURLs.compactMap { url -> Location? in
            guard !url.absoluteString.contains(".DS_Store") else {
                return nil
            }
            guard let data = try? Data(contentsOf: url) else {
                return nil
            }
            return try? jsonDecoder.decode(Location.self, from: data)
        }.sorted(by: { $0.date < $1.date })
    }
  
    // Write to JSON as means of Data Persistance
  func saveLocationJsonData(_ location: Location) {
        let encoder = JSONEncoder()
    // timeIntervalSince1970 initializer sets up the time in the UTC timezone
        let timestamp = location.date.timeIntervalSince1970
        let fileURL = documentsURL.appendingPathComponent("\(timestamp)")
        let data = try! encoder.encode(location)
        try! data.write(to: fileURL)
    
        locations.append(location)
    
        NotificationCenter.default.post(name: .locationSavedNew, object: self, userInfo: ["location": location])
    }
  
    // Core Location Location to Disk
    func saveCLLocationToDisk(_ clLocation: CLLocation) {
        let currentDate = Date()
        AppDelegate.geoCoder.reverseGeocodeLocation(clLocation) { placemarks, _ in
            if let place = placemarks?.first {
                let location = Location(clLocation.coordinate, date: currentDate, descriptionString: "\(place)")
                self.saveLocationJsonData(location)
                }
            }
        }
    }

extension Notification.Name {
  static let locationSavedNew = Notification.Name("LocationSaved")
}
