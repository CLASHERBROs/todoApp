//
//  AppDelegate.swift
//  Destini
//
//  Created by Philipp Muellauer on 01/09/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      // Override point for customization after application launch.
      let config = Realm.Configuration(
          // Set the new schema version. This must be greater than the previously used
          // version (if you've never set a schema version before, the version is 0).
          schemaVersion: 1,

          // Set the block which will be called automatically when opening a Realm with
          // a schema version lower than the one set above
          migrationBlock: { migration, oldSchemaVersion in
              // We haven’t migrated anything yet, so oldSchemaVersion == 0
              if (oldSchemaVersion < 1) {
                  // Nothing to do!
                  // Realm will automatically detect new properties and removed properties
                  // And will update the schema on disk automatically
              }
          })

      // Tell Realm to use this new configuration object for the default Realm
      Realm.Configuration.defaultConfiguration = config

      // Now that we've told Realm how to handle the schema change, opening the file
      // will automatically perform the migration
      
        
        
        
        print(Realm.Configuration.defaultConfiguration.fileURL)
       
        do{
              let realm = try Realm()
          
            
        }
              catch{
                  print(error)
              }
        
        let realm = try! Realm()
        return true
    }
    

    
    func applicationWillTerminate(_ application: UIApplication) {
        
        self.saveContext()
        
    }
    
    
    
    // MARK: - Core Data stack
    
    
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        
        
        let container = NSPersistentContainer(name: "DataModel")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                
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
                
                let nserror = error as NSError
                
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                
            }
            
        }
        
    }
    
    
    
    
    
}

