//
//  AppDelegate.swift
//  MAPD724_Assignment4
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
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    let rayWenderlichColor = UIColor(red: 0/255, green: 104/255, blue: 55/255, alpha: 1)
    UITabBar.appearance().tintColor = rayWenderlichColor
    return true
  }
}

