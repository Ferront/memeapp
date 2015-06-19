//
//  AppDelegate.swift
//  MemeApp
//
//  Created by Franck Ferront on 15/06/2015.
//  Copyright (c) 2015 UXperience. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var memes = [MemeObject]()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }


}

