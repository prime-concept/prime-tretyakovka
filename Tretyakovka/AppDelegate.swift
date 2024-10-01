//
//  AppDelegate.swift
//  Tretyakovka
//
//  Created by Александр Сабри on 02.12.2017.
//  Copyright © 2017 sabry. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FacebookCore
import FacebookLogin
import SwiftyVK
import CoreData

// MARK: - AppDelegate: UIResponder, UIApplicationDelegate
let defaults_user = UserDefaults.standard
var vkDelegateReference : SwiftyVKDelegate?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: Properties
    
    var window: UIWindow?
    
    // MARK: UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = .lightContent
        vkDelegateReference = VKDelegateExample()
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let stringURL = "\(url)"
        print("String from url")
        print(stringURL)
        let char = stringURL.first
        print("First Char")
        print(char)
        if char == "v" {
            print("Go to vk")
            VK.handle(url: url, sourceApplication: "com.vk.vkclient")
        } else if char == "f"{
            print("Go to fb")
            ApplicationDelegate.shared.application(app, open: url, options: options)
        }
        
        print(url)
        print(options)
        return true
    }
    
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEvents.activateApp()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Tretyakovka")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    
}




struct defaultsKeys {
    static let username = "username"
    static let userphone = ""
    static let useremail = "useremail"
    static let userSocialID = "userSocialID"
    static let useravatarURL = "userSocialID"
}
