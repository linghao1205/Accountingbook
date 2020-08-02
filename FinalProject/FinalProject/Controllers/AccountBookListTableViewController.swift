//
//  AccountBookListTableViewController.swift
//  FinalProject
//
//  Created by Linghao Du on 4/13/20.
//  Copyright © 2020 Linghao Du. All rights reserved.
//

import UIKit
import CoreData

class AccountBookListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var managedObjectContext: NSManagedObjectContext? = AppDelegate.viewContext
    var tempindexPath:IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        editButtonItem.tintColor = .white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
        
//        navigationController?.navigationBar.prefersLargeTitles = false
//        navigationController?.navigationBar.isTranslucent = false
//        navigationController?.navigationBar.barStyle = .default
//        navigationController?.navigationBar.barTintColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountBook", for: indexPath)

        // Configure the cell...
        let accountBook = fetchedResultsController.object(at: indexPath)
        configureCell(cell, withAccountBook: accountBook)
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return fetchedResultsController.sections![section].name
//    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerLable = UILabel()
        headerLable.text = "   " + fetchedResultsController.sections![section].name
        headerLable.textColor = .white
        switch fetchedResultsController.sections![section].name {
        case "Daily":
            headerLable.backgroundColor = UIColor(red: 178/255, green: 200/255, blue: 187/255, alpha: 1)
        case "Trival":
            headerLable.backgroundColor = UIColor(red: 69/255, green: 137/255, blue: 148/255, alpha: 1)
        case "Family":
            headerLable.backgroundColor = UIColor(red: 117/255, green: 121/255, blue: 74/255, alpha: 1)
        case "Business":
            headerLable.backgroundColor = UIColor(red: 114/255, green: 83/255, blue: 52/255, alpha: 1)
        default:
            headerLable.backgroundColor = .systemGray6
        }
        
        return headerLable
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let update = UIContextualAction(style: .normal, title: "Update") { (action, view, nil) in
            print("Update")
            self.tempindexPath = indexPath
            self.performSegue(withIdentifier: "Edit", sender: nil)
        }
        update.backgroundColor = UIColor.green
        return UISwipeActionsConfiguration(actions: [update])
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //tableView.deleteRows(at: [indexPath], with: .fade)
            let alert = UIAlertController(title: "Delete",
                                          message: "Are you sure you want to delete this account book?",
                                          preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                self.managedObjectContext?.delete(self.fetchedResultsController.object(at: indexPath))
                do {
                    try self.managedObjectContext!.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
            let cancelAction = UIAlertAction(title: "No", style: .default, handler: nil)
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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

    func configureCell(_ cell: UITableViewCell, withAccountBook accountBook: AccountBook) {
        cell.textLabel?.text = accountBook.name
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy-MM-dd"
        cell.detailTextLabel?.text = dformatter.string(from: accountBook.creationDate!)
    }
 
    // MARK: - Helping Function

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Edit" {
            //print(tempindexPath)
            if let uvc = segue.destination as? CreatAccountBookViewController {
                let obj = fetchedResultsController.object(at: tempindexPath!)
                //print(obj.name)
                uvc.accountbookname = obj.name!
                uvc.accountBook = obj
            }
        }
        if segue.identifier == "Detail" {
            let index = self.tableView.indexPathForSelectedRow
            if let dvc = segue.destination as? AccountBookDetailViewController {
                let obj = fetchedResultsController.object(at: index!)
                dvc.accountBook = obj
            }
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
    // MARK: - Fetched results controller

    var fetchedResultsController: NSFetchedResultsController<AccountBook> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<AccountBook> = AccountBook.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        let sortDescriptor2 = NSSortDescriptor(key: "type", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor2, sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: "type", cacheName: nil)
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
             // Replace this implementation with code to handle the error appropriately.
             // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             let nserror = error as NSError
             fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController<AccountBook>? = nil

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
            case .insert:
                tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            case .delete:
                tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            default:
                return
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                tableView.insertRows(at: [newIndexPath!], with: .fade)
            case .delete:
                tableView.deleteRows(at: [indexPath!], with: .fade)
            case .update:
                configureCell(tableView.cellForRow(at: indexPath!)!, withAccountBook: anObject as! AccountBook)
            case .move:
                configureCell(tableView.cellForRow(at: indexPath!)!, withAccountBook: anObject as! AccountBook)
                tableView.moveRow(at: indexPath!, to: newIndexPath!)
            default:
                return
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

}
