//
//  DataController.swift
//  CoreDataLargeImport
//
//  Created by Ivan Vranjic on 25/04/17.
//  Copyright © 2017 Ivan Vranjic. All rights reserved.
//

import Foundation
import CoreData

enum CoreDataStackType {
    case nested
    case sibling
}

class DataController {
    
    let mainContext: NSManagedObjectContext
    let backgroundContext: NSManagedObjectContext
    
    init(coreDataStackType: CoreDataStackType, storeName: String, deleteExistingStore: Bool = false) {
        guard let modelURL = Bundle.main.url(forResource: "Model", withExtension: "momd") else {
            fatalError("Error loading model from bundle")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing managed object model from: \(modelURL)")
        }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        switch coreDataStackType {
        case .nested:
            mainContext.persistentStoreCoordinator = psc
            backgroundContext.parent = mainContext
            mainContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        case .sibling:
            mainContext.persistentStoreCoordinator = psc
            backgroundContext.persistentStoreCoordinator = psc
            mainContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
            backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        }
        
        guard let storeURL = FileManager.default.storeURL(using: storeName) else {
            fatalError("Error creating store url")
        }
        
        do {
            if deleteExistingStore {
                try psc.destroyPersistentStore(at: storeURL, ofType: NSSQLiteStoreType, options: [:])
            }
        } catch {
            fatalError("Error deleting store: \(error)")
        }
        
        do {
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        } catch {
            fatalError("Error creating store: \(error)")
        }
        
    }
}

extension FileManager {
    
    func storeURL(using storeName: String) -> URL? {
        let documentsURL = self.urls(for: .documentDirectory, in: .userDomainMask).last
        return documentsURL?.appendingPathComponent(storeName)
    }
}
