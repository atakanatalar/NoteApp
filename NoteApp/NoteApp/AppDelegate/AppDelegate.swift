//
//  AppDelegate.swift
//  NoteApp
//
//  Created by Atakan Atalar on 11.10.2023.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var services: [AppDelegateServiceProtocol] = [IQKeyboardService()]
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        for service in services {
            service.application(application, launchOptions: launchOptions)
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let navigationController = SplashVC()
        
        if let window = self.window {
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
        
        return true
    }
}

