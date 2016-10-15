
//  AppDelegate.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 7/11/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        // Override point for customization after application launch.
        UINavigationBar.appearance().barTintColor = UIColor(red: 15/255, green: 127/255, blue: 223/255, alpha: 1)
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().disabledToolbarClasses.append(MapViewController.self)
        
        FIRApp.configure()
        
        if FIRAuth.auth()?.currentUser != nil {
            let storyboard = UIStoryboard(name: "Map", bundle: nil)
            let initialViewController = storyboard.instantiateInitialViewController()
            UIApplication.shared.delegate?.window??.rootViewController = initialViewController
        }
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {(accepted, error) in
            if !accepted {
                print("Notification access denied.")
            }
        }
        UNUserNotificationCenter.current().delegate = self
        
        
        //        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
        //            if let _ = user {
        //                //             úsuario autenticado/logado
        //                let storyboard = UIStoryboard(name: "Map", bundle: nil)
        //                let initialViewController = storyboard.instantiateInitialViewController()
        //                UIApplication.shared.delegate?.window??.rootViewController = initialViewController
        //            }
        //        })
        //        FIRAuth.auth()?.removeStateDidChangeListener(authListener!)
        
        return true

    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func scheduleNotification(at date: Date) {
        let current = formatTime(from: date).1

        let calendar = Calendar(identifier: .gregorian)
        
        let components = calendar.dateComponents(in: .current, from: current.addingTimeInterval(3600))
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute, second: components.second)

        
        print(newComponents)
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = "Azul Digital"
        content.body = "O ticket está prestes a vencer, favor comprar um novo ticket ou retirar o veículo do local estacionado"
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "myCategory"
        
        let request = UNNotificationRequest(identifier: "textNotification", content: content, trigger: trigger)
        
       
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print("Uh oh! We had an error: \(error)")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
        defaults.set(true, forKey: "buyButton")
        defaults.synchronize()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        defaults.set(true, forKey: "buyButton")
        defaults.synchronize()
        completionHandler()

    }
    
}

