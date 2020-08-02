//
//  AddOrUpdateDetailViewController.swift
//  FinalProject
//
//  Created by Linghao Du on 4/20/20.
//  Copyright © 2020 Linghao Du. All rights reserved.
//

import UIKit
import CoreData

class AddOrUpdateDetailViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var typeController: UISegmentedControl!
    @IBOutlet weak var purposePicker: UIPickerView!
    @IBOutlet weak var creatBtn: UIBarButtonItem!
    @IBOutlet weak var amountTxt: UITextField!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var commentsBtn: UIButton!
    
    var managedObjectContext: NSManagedObjectContext? = AppDelegate.viewContext
    var accountBook: AccountBook?
    var editingDetail: Detail?
    var editflag:Bool = false
    var comment:String = ""
    let incomeType = ["Salary", "Refund", "Part-time Job", "Bonus"]
    let paymentType = ["Food", "Marker Shopping", "Online Shopping", "Transportation", "Health Care"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        purposePicker.dataSource = self
        purposePicker.delegate = self
        amountTxt.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneClicked))
        
        toolBar.setItems([space, doneBtn], animated: true)
        amountTxt.inputAccessoryView = toolBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let numFormatter = NumberFormatter()
        numFormatter.minimumFractionDigits = 1
        numFormatter.maximumFractionDigits = 2
        
        if editflag {
            creatBtn.title = "Update"
            setPickers()
            amountTxt.text = numFormatter.string(from: NSNumber(value: editingDetail?.amount ?? 0.0))
            timePicker.setDate(editingDetail?.date ?? Date(), animated: true)
            self.comment = editingDetail?.comment ?? ""
        }
        else {
            creatBtn.title = "Create"
            self.comment = ""
            timePicker.setDate(Date(), animated: true)
            amountTxt.text = ""
        }
        timePicker.datePickerMode = .date
    }
    // MARK: - Update or Create
    
    @IBAction func addComment(_ sender: UIButton) {
        let addComAlert = UIAlertController(title: "Comment", message: "Please enter your comment", preferredStyle: .alert)
        addComAlert.addTextField(configurationHandler: nil)
        let okAction = UIAlertAction(title: "Done", style: .default) { _ in
            if let commentTxt = addComAlert.textFields?.first {
                self.comment = commentTxt.text!
                print(self.comment)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        addComAlert.addAction(okAction)
        addComAlert.addAction(cancelAction)
        present(addComAlert, animated: true)
    }
    
    @IBAction func addOrCreate(_ sender: UIBarButtonItem) {
        if editflag { //Update the detail
            let oldamount = editingDetail?.amount
            let segmentIndex = typeController.selectedSegmentIndex
            let type = typeController.titleForSegment(at: segmentIndex)
            let index = purposePicker.selectedRow(inComponent: 0)
            var purpose:String?
            if amountTxt.text != "" {
                let amountStr:String = amountTxt.text!
                let amount = Double(amountStr)
                editingDetail?.amount = amount!
                switch type {
                case "Income":
                    editingDetail?.accountBook?.income += (amount! - oldamount!)
                case "Payment":
                    editingDetail?.accountBook?.payed += (amount! - oldamount!)
                default:
                    break
                }
            }
            if segmentIndex == 0 {
                purpose = incomeType[index]
            } else {
                purpose = paymentType[index]
            }
            let date = timePicker.date
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM"
            let createMonth = formatter.string(from: date)
            editingDetail?.type = type
            editingDetail?.date = date
            editingDetail?.purpose = purpose
            editingDetail?.createMonth = createMonth
            editingDetail?.comment = self.comment
            
            do {
                try managedObjectContext!.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            
            let alert = UIAlertController(title: "Message", message: "Update Success!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style:UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            //validation of amount
            if amountTxt.text == "" {
                let alert = UIAlertController(title: "Alert", message: "Amount should not be empty", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style:UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            //validataion of date
            let curDate = Date()
            if timePicker.date > curDate {
                let alert = UIAlertController(title: "Alert", message: "The time you set should not later than current time", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style:UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            // Creat the detail
            let newDetail = Detail(context: managedObjectContext!)
            let amountStr = amountTxt.text!
            let amount = Double(amountStr)
            let segmentIndex = typeController.selectedSegmentIndex
            let type = typeController.titleForSegment(at: segmentIndex)
            let index = purposePicker.selectedRow(inComponent: 0)
            var purpose:String?
            if segmentIndex == 0 {
                purpose = incomeType[index]
            } else {
                purpose = paymentType[index]
            }
            let date = timePicker.date
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM"
            let createMonth = formatter.string(from: date)
            newDetail.amount = amount!
            newDetail.type = type
            newDetail.date = date
            newDetail.purpose = purpose
            newDetail.createMonth = createMonth
            newDetail.comment = self.comment
            newDetail.accountBook = self.accountBook
            switch type {
            case "Income":
                newDetail.accountBook?.income += amount!
            case "Payment":
                newDetail.accountBook?.payed += amount!
            default:
                break
            }
            //accountBook?.accountDetail?.adding(newDetail)
            
            do {
                try managedObjectContext!.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            
            let alert = UIAlertController(title: "Message", message: "Create Success!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style:UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Helping functions
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }

        let newText = oldText.replacingCharacters(in: r, with: string)
        let isNumeric = newText.isEmpty || (Double(newText) != nil)
        let numberOfDots = newText.components(separatedBy: ".").count - 1

        let numberOfDecimalDigits: Int
        if let dotIndex = newText.firstIndex(of: ".") {
            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
        } else {
            numberOfDecimalDigits = 0
        }

        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
    }
    
    func setPickers() {
        
        let type:String = (editingDetail?.type)!
        let purpose:String = (editingDetail?.purpose)!
        let index:Int?
        switch type {
        case "Income":
            typeController.selectedSegmentIndex = 0
            index = incomeType.firstIndex(of: purpose)
            purposePicker.selectRow(index!, inComponent: 0, animated: true)
        case "Payment":
            typeController.selectedSegmentIndex = 1
            index = paymentType.firstIndex(of: purpose)
            purposePicker.selectRow(index!, inComponent: 0, animated: true)
        default:
            break
        }
        
    }
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
    
    // MARK: - PickerView and Segemented Control
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        self.purposePicker.reloadComponent(0)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch typeController.selectedSegmentIndex {
        case 0:
            return incomeType.count
        case 1:
            return paymentType.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch typeController.selectedSegmentIndex {
        case 0:
            return incomeType[row]
        case 1:
            return paymentType[row]
        default:
            return ""
        }
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
