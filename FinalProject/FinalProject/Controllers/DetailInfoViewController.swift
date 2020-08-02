//
//  DetailInfoViewController.swift
//  FinalProject
//
//  Created by Linghao Du on 4/20/20.
//  Copyright © 2020 Linghao Du. All rights reserved.
//

import UIKit
import CoreData

class DetailInfoViewController: UIViewController {
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var purposeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextView!
    
    var managedObjectContext:NSManagedObjectContext = AppDelegate.viewContext
    var detail:Detail?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.commentTextField.layer.borderColor = UIColor(red: 60/255, green: 40/255, blue: 129/255, alpha: 1).cgColor
        self.commentTextField.layer.borderWidth = 2
        self.commentTextField.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
        navigationItem.title = "Detail"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setLabels()
    }
    
    // MARK: - Create and Delete
    
    @IBAction func deleteDetail(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Delete",
                                      message: "Are you sure you want to delete it",
                                      preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.managedObjectContext.delete(self.detail!)
            do {
                try self.managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            self.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "No", style: .default, handler: nil)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    
    // MARK: - Helping Functions
    func setLabels(){
        let numFormatter = NumberFormatter()
        numFormatter.minimumFractionDigits = 1
        numFormatter.maximumFractionDigits = 2
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy.MM.dd"
        
        amountLabel.text = numFormatter.string(from: NSNumber(value: detail?.amount ?? 0.0))
        typeLabel.text = detail?.type ?? "Null"
        purposeLabel.text = detail?.purpose ?? "Null"
        dateLabel.text = dformatter.string(from: detail?.date ?? Date())
        if let comment = detail?.comment {
            if comment == "" {
                commentTextField.text = "No comment"
                commentTextField.textColor = .systemGray4
            } else {
                commentTextField.text = comment
                commentTextField.textColor = .black
            }
        }
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Update" {
            if let uvc = segue.destination as? AddOrUpdateDetailViewController {
                uvc.editflag = true
                uvc.editingDetail = self.detail
            }
        }
    }
    

}
