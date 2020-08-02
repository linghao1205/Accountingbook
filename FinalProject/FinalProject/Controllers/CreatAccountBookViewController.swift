//
//  CreatAccountBookViewController.swift
//  FinalProject
//
//  Created by Linghao Du on 4/20/20.
//  Copyright © 2020 Linghao Du. All rights reserved.
//

import UIKit
import CoreData

class CreatAccountBookViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    

    @IBOutlet weak var accountBookNameTxt: UITextField!
    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var creatAndUpdateBtn: UIBarButtonItem!
    let types = ["Daily", "Trival", "Family", "Business"]
    var managedObjectContext:NSManagedObjectContext = AppDelegate.viewContext
    var accountbookname = ""
    var accountBook:AccountBook?

    override func viewDidLoad() {
        super.viewDidLoad()

        typePicker.delegate = self
        typePicker.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if accountbookname != "" {
            accountBookNameTxt.text = accountbookname
            creatAndUpdateBtn.title = "Update"
            let index = types.firstIndex(of: accountBook!.type!)
            typePicker.selectRow(index!, inComponent: 0, animated: true)
        }
        else {
            accountBookNameTxt.placeholder = ""
            creatAndUpdateBtn.title = "Create"
        }
    }
    
    // MARK: - Setting picker
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return types.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return types[row]
    }
    
    // MARK: - Creat or update function
    
    @IBAction func creatAccountBook(_ sender: UIBarButtonItem) {
        
        if accountbookname == "" { //Create new Account Book
            //validation
            if accountBookNameTxt.text == "" || accountBookNameTxt.text!.removeAllSapce == "" {
                let alert = UIAlertController(title: "Alert", message: "The name of account book should not be empty", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style:UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            let index = self.typePicker.selectedRow(inComponent: 0)
            let type = types[index]
            let name:String = accountBookNameTxt.text!
            let income:Double = 0
            let payed:Double = 0
            let creationDate = Date()
            let context = AppDelegate.viewContext
            let newAccountBook = AccountBook(context: context)
            newAccountBook.income = income
            newAccountBook.payed = payed
            newAccountBook.creationDate = creationDate
            newAccountBook.name = name
            newAccountBook.type = type
            //newAccountBook.id = AppDelegate.accountBookId
            //AppDelegate.accountBookId += 1
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            
            let alert = UIAlertController(title: "Message", message: "Account book create successfully", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style:UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else { //update account book
            if accountBookNameTxt.text != "" {
                accountBook?.name = accountBookNameTxt.text
            }
            let index = self.typePicker.selectedRow(inComponent: 0)
            let type = types[index]
            accountBook?.type = type
            
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            let alert = UIAlertController(title: "Message", message: "Account book update successfully", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style:UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func exit(_ sender: UITextField) {
        sender.resignFirstResponder()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension String {
    var removeAllSapce: String {
        return self.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }
}
