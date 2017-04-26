//
//  NSManagedObjectContext+Extensions.swift
//  CoreDataLargeImport
//
//  Created by Ivan Vranjic on 25/04/17.
//  Copyright © 2017 Ivan Vranjic. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    
    func insertUser(i: Int) {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "User", into: self)
        entity.setValue("id\(i)", forKey: "id")
        entity.setValue("name\(i)", forKey: "name")
    }
}
