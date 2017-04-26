//
//  SiblingContextsExampleViewController.swift
//  CoreDataLargeImport
//
//  Created by Ivan Vranjic on 25/04/17.
//  Copyright © 2017 Ivan Vranjic. All rights reserved.
//

import UIKit
import CoreData

class SiblingContextsExampleViewController: UIViewController {

    var dataController: DataController!
    
    let itemsCount = 300000
    let saveFrequencyCount = 3000
    
    convenience init(dataController: DataController) {
        self.init()
        self.dataController = dataController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Sibling contexts"
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleContextSaved(_:)),
                                               name: .NSManagedObjectContextDidSave,
                                               object: nil)
    }
    
    @IBAction func startImportTapped(_ sender: UIButton) {
        dataController.backgroundContext.perform { [weak self] in
            guard let `self` = self else { return }
            for i in 0..<self.itemsCount {
                self.dataController.backgroundContext.insertUser(i: i)
                
                if i % self.saveFrequencyCount == 0 {
                    print(i)
                    try! self.dataController.backgroundContext.save()
                    self.dataController.backgroundContext.reset()
                }
            }
            try! self.dataController.backgroundContext.save()
            self.dataController.backgroundContext.reset()
        }
    }
    
    func handleContextSaved(_ notification: Notification) {
        let sender = notification.object as! NSManagedObjectContext
        if sender == dataController.backgroundContext {
            dataController.mainContext.perform { [weak self] in
                guard let `self` = self else { return }
                
                //for ios 9 only
//                let objectsFromNotification = notification.userInfo?[NSUpdatedObjectsKey] as! Set<NSManagedObject>
//                let objectsToUpdate = objectsFromNotification.subtracting(self.dataController.mainContext.registeredObjects)
//                for object in objectsToUpdate {
//                    let obj = self.dataController.mainContext.object(with: object.objectID)
//                    obj.willAccessValue(forKey: nil)
//                }
                
                self.dataController.mainContext.mergeChanges(fromContextDidSave: notification)
                print("merged to main")
                
                //works also on ios 9
//                let objectsFromNotification = notification.userInfo?[NSUpdatedObjectsKey] as! Set<NSManagedObject>
//                let objectsToUpdate = objectsFromNotification.subtracting(self.dataController.mainContext.registeredObjects)
//                for object in objectsToUpdate {
//                    let obj = try! self.dataController.mainContext.existingObject(with: object.objectID)
//                    self.dataController.mainContext.refresh(obj, mergeChanges: true)
//                }
            }
        }
    }

}
