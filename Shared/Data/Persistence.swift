//
//  Persistence.swift
//  Temp
//
//  Created by Christopher Engelbart on 5/31/22.
//

import CoreData

/**
 Core Data access and container struct
 */
struct PersistenceController {
    
    /// Main point of access to Core Data store, unless in Preview or Unit Tests
    static let shared = PersistenceController()
    
    /// Main point of access to Core Data store for Unit Tests.
    /// Doesn't save data into store.
    static let inMemory = PersistenceController(persistence: false)
    
    /// Access Core Data store in a Preview
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = DrinkType(context: viewContext)
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    let container: NSPersistentContainer

    /**
     Create a new Persistence Controller
     - Parameters:
        - inMemory: Whether or not Core Data objects are storied in memory; defaults to `false`
        - persistence: Whether or not changes made to the data store should be saved or not; defaults to `true`
     */
    init(inMemory: Bool = false, persistence: Bool = true) {
        // Get the `sharedKey` URL
        let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Constants.sharedKey)!
        
        // Get the url of the Liquidus Data Model
        let storeURL = containerURL.appendingPathComponent("Liquidus Data Model.xcdatamodeld")
        
        // Create description
        let description = NSPersistentStoreDescription()
        
        // Set Persistence Method and Stor URL
        // persistence is false when called from a Unit Test
        if persistence {
            description.type = NSSQLiteStoreType
            description.url = storeURL
        
        } else {
            description.type = NSInMemoryStoreType
        }
        
        container = NSPersistentContainer(name: "Liquidus Data Model")
        container.persistentStoreDescriptions = [description]
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
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
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    /// Save changes made to Core Data entities
    func saveContext() {
        self.container.viewContext.performAndWait {
            if self.container.viewContext.hasChanges {
                
                do {
                    try container.viewContext.save()
                } catch {
                    fatalError("Persistence: saveContext: \(error.localizedDescription)")
                }
                
            }
        }
    }
}
