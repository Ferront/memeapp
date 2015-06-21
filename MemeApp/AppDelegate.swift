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
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if self.memes.count == 0 {
            var initialViewController = storyboard.instantiateViewControllerWithIdentifier("ViewController") as! UIViewController
            
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }else{
            
            //TODO
            //var initialViewController = storyboard.instantiateViewControllerWithIdentifier("SentMemesVC") as! SentMemesTableViewController
            
            //self.window?.rootViewController = initialViewController
        }
        
        return true
    }
    
 
    
    
}

