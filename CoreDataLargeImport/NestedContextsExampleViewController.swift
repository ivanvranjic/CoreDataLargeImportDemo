//
//  NestedContextsExampleViewController.swift
//  CoreDataLargeImport
//
//  Created by Ivan Vranjic on 25/04/17.
//  Copyright © 2017 Ivan Vranjic. All rights reserved.
//

import UIKit
import CoreData

class NestedContextsExampleViewController: UIViewController {

    var dataController: DataController!
    
    let itemsCount = 300000
    let saveFrequencyCount = 3000
    
    convenience init(dataController: DataController) {
        self.init()
        self.dataController = dataController
    }
    
    override func viewDidLoad() {
        self.title = "Nested contexts"
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
                    self.dataController.mainContext.perform {
                        try! self.dataController.mainContext.save()
                    }
                }
            }
            try! self.dataController.backgroundContext.save()
            self.dataController.backgroundContext.reset()
            self.dataController.mainContext.perform {
                try! self.dataController.mainContext.save()
            }
        }
    }

}
