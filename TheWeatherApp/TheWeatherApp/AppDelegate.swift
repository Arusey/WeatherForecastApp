//
//  AppDelegate.swift
//  TheWeatherApp
//
//  Created by Kevin Lagat on 1/14/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let home = HomeController()
        let navController = UINavigationController(rootViewController: home)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        return true
    }


}

