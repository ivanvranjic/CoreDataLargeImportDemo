//
//  ExamplesTableViewController.swift
//  CoreDataLargeImport
//
//  Created by Ivan Vranjic on 25/04/17.
//  Copyright © 2017 Ivan Vranjic. All rights reserved.
//

import UIKit

class ExamplesTableViewController: UITableViewController {

    let cellReuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Examples"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        if indexPath.row == 0 {
            cell.textLabel?.text = "Nested Contexts"
        } else if (indexPath.row == 1) {
            cell.textLabel?.text = "Sibling Contexts"
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            let dataController = DataController(coreDataStackType: .nested, storeName: "database.sqlite", deleteExistingStore: true)
            let vc = NestedContextsExampleViewController(dataController: dataController)
            navigationController?.pushViewController(vc, animated: true)
        } else if (indexPath.row == 1) {
            let dataController = DataController(coreDataStackType: .sibling, storeName: "database.sqlite", deleteExistingStore: true)
            let vc = SiblingContextsExampleViewController(dataController: dataController)
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}
