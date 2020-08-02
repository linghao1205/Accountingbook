//
//  AccountBookDetailViewController.swift
//  FinalProject
//
//  Created by Linghao Du on 4/20/20.
//  Copyright © 2020 Linghao Du. All rights reserved.
//

import UIKit
import CoreData

class AccountBookDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate {
    
    var accountBook: AccountBook?
    //var accountBookid: Int64?
    var managedObjectContext:NSManagedObjectContext = AppDelegate.viewContext
    var details = Set<Detail>()
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var payedLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
//        
        
//        navigationController?.navigationBar.isTranslucent = false
//        navigationController?.navigationBar.barStyle = .default
//        navigationController?.navigationBar.barTintColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
//        //navigationController?.navigationBar.backgroundColor = .blue
        navigationItem.title = self.accountBook?.name
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy-MM"
        let curDate = dformatter.string(from: Date())
        updateData(curDate: curDate)
        
        //test
        //print(accountBook?.name)
        let dformattertest = DateFormatter()
        dformattertest.dateFormat = "yyyy-MM-dd"
        //print(dformattertest.string(from: accountBook!.creationDate!))
        details = accountBook?.accountDetail as? Set ?? Set<Detail>()
        //print(details.count)
    }
    
    func updateData(curDate:String) {
        var income:Double = 0.0
        var payment:Double = 0.0
        
        if let details = fetchedResultsController.fetchedObjects {
            
            for detail in details {
                if detail.createMonth == curDate {
                    if detail.type == "Income" {
                        income += detail.amount
                    } else {
                        payment += detail.amount
                    }
                }
            }
        }
        
        let numFormatter = NumberFormatter()
        numFormatter.minimumFractionDigits = 1
        numFormatter.maximumFractionDigits = 2
        let total:Double = income - payment
        print("income is \(income)")
        print("paymeny si \(payment)")
        
        incomeLabel.text = numFormatter.string(from: NSNumber(value: income))
        payedLabel.text = numFormatter.string(from: NSNumber(value: payment))
        statusLabel.text = numFormatter.string(from: NSNumber(value: total))
        
        if total < -100.0 {
            backgroundView.backgroundColor = UIColor(red: 241/255, green: 132/255, blue: 120/255, alpha: 1)
        } else if total > 100.0 {
            backgroundView.backgroundColor = UIColor(red: 191/255, green: 250/255, blue: 174/255, alpha: 1)
        } else {
            backgroundView.backgroundColor = UIColor(red: 251/255, green: 246/255, blue: 130/255, alpha: 1)
        }
    }
    
    
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.sections![section].numberOfObjects
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerLable = UILabel()
        headerLable.text = "   " + fetchedResultsController.sections![section].name
        headerLable.backgroundColor = .systemGray6
        return headerLable
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailInformation", for: indexPath) as! DetailTableViewCell

        
        // Configure the cell...
        cell.selectionStyle = .none
        let detail = fetchedResultsController.object(at: indexPath)
        configureCell(cell, withDetail: detail)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let pathsForVisibleRows = tableView.indexPathsForVisibleRows,
        let firstPath = pathsForVisibleRows.first else { return }
        
        print("Decelerating End")
        updateData(curDate: fetchedResultsController.object(at: firstPath).createMonth!)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
         guard let pathsForVisibleRows = tableView.indexPathsForVisibleRows,
        let firstPath = pathsForVisibleRows.first else { return }
               
        print("Dragging End")
        updateData(curDate: fetchedResultsController.object(at: firstPath).createMonth!)
    }

    func configureCell(_ cell: DetailTableViewCell, withDetail detail: Detail) {
        cell.mainLabel.text = String(detail.amount)
        if detail.type == "Income" {
            cell.mainLabel.textColor = .green
        } else {
            cell.mainLabel.textColor = .black
        }
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy-MM-dd"
        cell.dateLabel.text = dformatter.string(from: detail.date!)
        cell.purposeLabel.text = detail.purpose!
    }
    
    // MARK: - Fetched results controller

    var fetchedResultsController: NSFetchedResultsController<Detail> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
           
        let fetchRequest: NSFetchRequest<Detail> = Detail.fetchRequest()
           
        // Set the batch size to a suitable number.
        //fetchRequest.fetchBatchSize = 20
           
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        let sortDescriptor2 = NSSortDescriptor(key: "createMonth", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor2, sortDescriptor]
        
        // Edit the predicate
        fetchRequest.predicate = NSPredicate(format: "accountBook == %@", accountBook!)
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: "createMonth", cacheName: nil)
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
           
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
           
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController<Detail>? = nil

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
                configureCell(tableView.cellForRow(at: indexPath!)! as! DetailTableViewCell, withDetail: anObject as! Detail)
            case .move:
                configureCell(tableView.cellForRow(at: indexPath!)! as! DetailTableViewCell, withDetail: anObject as! Detail)
                tableView.moveRow(at: indexPath!, to: newIndexPath!)
            default:
                return
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "AddDetail" {
            if let avc = segue.destination as? AddOrUpdateDetailViewController {
                avc.accountBook = self.accountBook
                avc.editflag = false
            }
        }
        if segue.identifier == "View" {
            let index = self.tableView.indexPathForSelectedRow
            if let vvc = segue.destination as? DetailInfoViewController {
                vvc.detail = fetchedResultsController.object(at: index!)
            }
        }
        if segue.identifier == "OverView" {
            if let ovc = segue.destination as? OverviewViewController {
                ovc.accountBook = self.accountBook
            }
        }
    }
}
