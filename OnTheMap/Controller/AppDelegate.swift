//
//  AppDelegate.swift
//  OnTheMap
//
//  Created by user on 12.04.2020.
//  Copyright © 2020 ulkoart. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var locations = [Location]()
    var student: Student?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

}
