//
//  dateChooseViewController.swift
//  FinalProject
//
//  Created by Linghao Du on 4/22/20.
//  Copyright © 2020 Linghao Du. All rights reserved.
//

import UIKit

class dateChooseViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var fromPicker: UIDatePicker!
    @IBOutlet weak var toPicker: UIDatePicker!
    
    var curDate: Date?
    var lastDate: Date?
    let dateformatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fromPicker.datePickerMode = .date
        toPicker.datePickerMode = .date
        
        fromPicker.setDate(lastDate ?? Date(), animated: true)
        toPicker.setDate(curDate ?? Date(), animated: true)
        
        setLabel()
    }
    
    @IBAction func changeFrom(_ sender: UIDatePicker) {
        // validation
        if fromPicker.date > curDate! {
            let alert = UIAlertController(title: "Alert", message: "The start time should no later than end time", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style:UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            fromPicker.setDate(lastDate ?? Date(), animated: true)
            return
        }
        
        lastDate = fromPicker.date
        setLabel()
        
    }
    
    @IBAction func changeTo(_ sender: UIDatePicker) {
        //validation
        if toPicker.date < fromPicker.date || toPicker.date > Date() {
            let alert = UIAlertController(title: "Alert", message: "The end time is invalid", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style:UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            toPicker.setDate(curDate ?? Date(), animated: true)
            return
        }
        curDate = toPicker.date
        
        setLabel()
    }
    
    
    // MARK: - Helping Functions
    
    func setLabel() {
        dateformatter.dateFormat = "yyyy.MM.dd"
        dateLabel.text = "\(dateformatter.string(from: lastDate!)) - \(dateformatter.string(from: curDate!))"
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
