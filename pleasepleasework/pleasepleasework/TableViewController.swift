//
//  TableViewController.swift
//  pleasepleasework
//
//  Created by ani kvitsiani on 05.11.23.
//

import Foundation
import UIKit

class TableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell") // Register a cell class
        tableView.dataSource = self // Set the data source
    }

    // Implement data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5 //some random number for the notes
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "Note \(indexPath.row + 1)"
        //note 1, note 2 for example, up to 6

        return cell
    }
    
    func deleteRow(at indexPath: IndexPath) {
//        someArrayOfNotes.remove(at: indexPath.row) //here i will have some array of notes and we will delete specific one from that list
        
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    
}
