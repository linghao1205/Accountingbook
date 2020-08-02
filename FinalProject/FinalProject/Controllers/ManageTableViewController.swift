//
//  ManageTableViewController.swift
//  FinalProject
//
//  Created by Linghao Du on 4/13/20.
//  Copyright © 2020 Linghao Du. All rights reserved.
//

import UIKit
import CoreData

class ManageTableViewController: UITableViewController {
    
    var managedObjectContext: NSManagedObjectContext? = AppDelegate.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Setting"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return ManagementSection.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let menuSection = ManagementSection(rawValue: section) else { return 0 }
        
        switch menuSection {
        case .Manage:
            return ManageOptions.allCases.count
        case .test:
            return testOptions.allCases.count
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .systemGray6
        
        let title = UILabel()
        
        title.text = ManagementSection(rawValue: section)?.description
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        return view
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManageCell", for: indexPath)

        guard let menuSection = ManagementSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch menuSection {
        case .Manage:
            let manage = ManageOptions(rawValue: indexPath.row)
            cell.textLabel?.text = manage?.description
       case .test:
            let test = testOptions(rawValue: indexPath.row)
            cell.textLabel?.text = test?.description
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuSection = ManagementSection(rawValue: indexPath.section) else { return }
        
        switch menuSection {
        case .Manage:
            let manage = ManageOptions(rawValue: indexPath.row)
            if manage?.description == "Clean Data" {
                let alert = UIAlertController(title: "Delete",
                                              message: "Are you sure you want to delete all the account book?",
                                              preferredStyle: .alert)
                let deleteAction = UIAlertAction(title: "Yes", style: .default) { (action) in

                    do {
                        let items = try self.managedObjectContext?.fetch(AccountBook.fetchRequest())

                        for item in items! {
                            self.managedObjectContext!.delete(item as! NSManagedObject)
                        }
                        // Save Changes
                        try self.managedObjectContext!.save()
                    } catch {
                        // Error Handling
                    }
                }
                let cancelAction = UIAlertAction(title: "No", style: .default, handler: nil)
                alert.addAction(deleteAction)
                alert.addAction(cancelAction)
                present(alert, animated: true)
            }
        case .test:
            let alert = UIAlertController(title: "Message", message: "This is a test", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style:UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
