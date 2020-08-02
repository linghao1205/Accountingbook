//
//  OverviewViewController.swift
//  FinalProject
//
//  Created by Linghao Du on 4/20/20.
//  Copyright © 2020 Linghao Du. All rights reserved.
//

import UIKit

struct DataSet {
    let dataName:String
    let dataValue:Double
    let dataPercent:Double
    
    init(name:String, value:Double, percent:Double) {
        self.dataName = name
        self.dataValue = value
        self.dataPercent = percent
    }
}

class OverviewViewController: UIViewController {
    
    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet weak var totalIncomeLabel: UILabel!
    @IBOutlet weak var totalPaymentLabel: UILabel!
    
    @IBOutlet weak var firstIncomeNameLabel: UILabel!
    @IBOutlet weak var secondIncomeNameLabel: UILabel!
    @IBOutlet weak var thirdIncomeNameLabel: UILabel!
    @IBOutlet weak var forthIncomeNameLabel: UILabel!
    
    @IBOutlet weak var firstIncomeAmountLabel: UILabel!
    @IBOutlet weak var seconedIncomeAmountLabel: UILabel!
    @IBOutlet weak var thirdIncomeAmountLabel: UILabel!
    @IBOutlet weak var forthIncomeAmountLabel: UILabel!
    
    @IBOutlet weak var firstIncomePercentageLabel: UILabel!
    @IBOutlet weak var secondIncomePercentageLabel: UILabel!
    @IBOutlet weak var thirdIncomePercentageLabel: UILabel!
    @IBOutlet weak var forthIncomePercentageLabel: UILabel!
    
    @IBOutlet weak var firstPaymentNameLabel: UILabel!
    @IBOutlet weak var secondPaymentNameLabel: UILabel!
    @IBOutlet weak var thirdPaymentNameLabel: UILabel!
    @IBOutlet weak var forthPaymentNameLabel: UILabel!
    @IBOutlet weak var fifthPaymentNameLabel: UILabel!
    
    @IBOutlet weak var firstPaymentAmountLabel: UILabel!
    @IBOutlet weak var secondPaymentAmountLabel: UILabel!
    @IBOutlet weak var thirdPaymentAmountLabel: UILabel!
    @IBOutlet weak var forthPaymentAmountLabel: UILabel!
    @IBOutlet weak var fifthPaymentAmountLabel: UILabel!
    
    @IBOutlet weak var firstPaymentPercentageLabel: UILabel!
    @IBOutlet weak var secondPaymentPercentageLabel: UILabel!
    @IBOutlet weak var thirdPaymentPercentageLabel: UILabel!
    @IBOutlet weak var forthPaymentPercentageLabel: UILabel!
    @IBOutlet weak var fifthPaymentPercentageLabel: UILabel!
    
    @IBOutlet weak var infoChangeController: UISegmentedControl!
    
    var accountBook: AccountBook?
    var curDateO: Date?
    var lastDateO: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        curDateO = Date()
        lastDateO = getLastDay(curDateO!, days: 6)
        
        calculateData(curDate: curDateO!, lastDate: lastDateO!)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

    }
    
    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        if infoChangeController.selectedSegmentIndex == 1 {
            dateBtn.isEnabled = false
            
            let curDate = Date()
            var lastDate = Date()
            
            if let details = self.accountBook?.accountDetail as? Set<Detail> {
                for detail in details {
                    if detail.date! < lastDate {
                        lastDate = detail.date!
                    }
                }
            }
            
            calculateData(curDate: curDate, lastDate: lastDate)
            
        }
        
        if infoChangeController.selectedSegmentIndex == 0 {
            dateBtn.isEnabled = true
            
            let curDate = Date()
            let lastDate = getLastDay(curDate, days: 6)
            
            calculateData(curDate: curDate, lastDate: lastDate)
        }
    }
    
    
    // MARK: - Helping Function
    
    func getLastDay(_ nowDay: Date, days: Double) -> Date {
        //let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "yyyy.MM.dd"
            
        //let date = dateFormatter.date(from: nowDay)
        let date = nowDay
        let lastTime: TimeInterval = -(24*60*60*days)
            
        let lastDate = date.addingTimeInterval(lastTime)
        //let lastDay = dateFormatter.string(from: lastDate!)
        //return lastDay
        return lastDate
    }
    
    func calculateData(curDate: Date, lastDate: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        dateBtn.setTitle("\(dateFormatter.string(from: lastDate)) - \(dateFormatter.string(from: curDate))", for: .normal)
        
        var totalIncome:Double = 0.0
        var totalPayment:Double = 0.0
        var salary:Double = 0.0
        var partTime:Double = 0.0
        var refund:Double = 0.0
        var bonus:Double = 0.0
        var food:Double = 0.0
        var market:Double = 0.0
        var online:Double = 0.0
        var transport:Double = 0.0
        var health:Double = 0.0
        
        var salaryPercent:Double = 0.0
        var partTimePercet:Double = 0.0
        var refundPercent:Double = 0.0
        var bonusPercent:Double = 0.0
        var foodPercent:Double = 0.0
        var marketPercent:Double = 0.0
        var onlinePercent:Double = 0.0
        var transportPercent:Double = 0.0
        var healthPercent:Double = 0.0
        
        //print("outSide")
        //print(accountBook?.name)
        //let startTime: TimeInterval = -(24*60*60)
        let endTime: TimeInterval = (24*60*60)
        
        //let startDate = lastDate.addingTimeInterval(startTime)
        let endDate = curDate.addingTimeInterval(endTime)
        let curZeroDate = endDate.currentZeroDate
        let lastZeroDate = lastDate.currentZeroDate
        
        if let details = accountBook?.accountDetail as? Set<Detail> {
            //print("Inside")
            for detail in details {
                //print(detail.date)
                if detail.date! <= curZeroDate && detail.date! >= lastZeroDate {
                    //print("Valid")
                    let type = detail.type
                    let purpose = detail.purpose
                    switch type {
                    case "Income":
                        totalIncome += detail.amount
                        switch purpose {
                        case "Salary":
                            salary += detail.amount
                        case "Refund":
                            refund += detail.amount
                        case "Part-time Job":
                            partTime += detail.amount
                        case "Bonus":
                            bonus += detail.amount
                        default:
                            break
                        }
                    case "Payment":
                        totalPayment += detail.amount
                        switch purpose {
                        case "Food":
                            food += detail.amount
                        case "Marker Shopping":
                            market += detail.amount
                        case "Online Shopping":
                            online += detail.amount
                        case "Transportation":
                            transport += detail.amount
                        case "Health Care":
                            health += detail.amount
                        default:
                            break
                        }
                    default:
                        break
                    }
                    
                    //calculate percentage
                    if totalIncome != 0.0 {
                        salaryPercent = (salary / totalIncome) * 100
                        refundPercent = (refund / totalIncome) * 100
                        partTimePercet = (partTime / totalIncome) * 100
                        bonusPercent = (bonus / totalIncome) * 100
                    }
                    
                    if totalPayment != 0.0 {
                        foodPercent = (food / totalPayment) * 100
                        marketPercent = (market / totalPayment) * 100
                        onlinePercent = (online / totalPayment) * 100
                        transportPercent = (transport / totalPayment) * 100
                        healthPercent = (health / totalPayment) * 100
                    }

                }
            }
        }
        
        let numFormatter = NumberFormatter()
        numFormatter.minimumFractionDigits = 1
        numFormatter.maximumFractionDigits = 2
        
        //set total numbers
        totalIncomeLabel.text = numFormatter.string(from: NSNumber(value: totalIncome))
        totalPaymentLabel.text = numFormatter.string(from: NSNumber(value: totalPayment))
        
        //sort
        var incomeArray = [DataSet]()
        incomeArray.append(DataSet(name: "Salary", value: salary, percent: salaryPercent))
        incomeArray.append(DataSet(name: "Refund", value: refund, percent: refundPercent))
        incomeArray.append(DataSet(name: "Part-time", value: partTime, percent: partTimePercet))
        incomeArray.append(DataSet(name: "Bonus", value: bonus, percent: bonusPercent))
        var paymentArray = [DataSet]()
        paymentArray.append(DataSet(name: "Food", value: food, percent: foodPercent))
        paymentArray.append(DataSet(name: "Market", value: market, percent: marketPercent))
        paymentArray.append(DataSet(name: "Online", value: online, percent: onlinePercent))
        paymentArray.append(DataSet(name: "Transportation", value: transport, percent: transportPercent))
        paymentArray.append(DataSet(name: "Health Care", value: health, percent: healthPercent))
        
        incomeArray.sort(by: {$0.dataValue >= $1.dataValue})
        paymentArray.sort(by: {$0.dataValue >= $1.dataValue})
        
        firstIncomeNameLabel.text = incomeArray[0].dataName
        firstIncomeAmountLabel.text = numFormatter.string(from: NSNumber(value: incomeArray[0].dataValue))
        firstIncomePercentageLabel.text = numFormatter.string(from: NSNumber(value: incomeArray[0].dataPercent))! + "%"
        
        secondIncomeNameLabel.text = incomeArray[1].dataName
        seconedIncomeAmountLabel.text = numFormatter.string(from: NSNumber(value: incomeArray[1].dataValue))
        secondIncomePercentageLabel.text = numFormatter.string(from: NSNumber(value: incomeArray[1].dataPercent))! + "%"
        
        thirdIncomeNameLabel.text = incomeArray[2].dataName
        thirdIncomeAmountLabel.text = numFormatter.string(from: NSNumber(value: incomeArray[2].dataValue))
        thirdIncomePercentageLabel.text = numFormatter.string(from: NSNumber(value: incomeArray[2].dataPercent))! + "%"
        
        forthIncomeNameLabel.text = incomeArray[3].dataName
        forthIncomeAmountLabel.text = numFormatter.string(from: NSNumber(value: incomeArray[3].dataValue))
        forthIncomePercentageLabel.text = numFormatter.string(from: NSNumber(value: incomeArray[3].dataPercent))! + "%"
        
        firstPaymentNameLabel.text = paymentArray[0].dataName
        firstPaymentAmountLabel.text = numFormatter.string(from: NSNumber(value: paymentArray[0].dataValue))
        firstPaymentPercentageLabel.text = numFormatter.string(from: NSNumber(value: paymentArray[0].dataPercent))! + "%"
        
        secondPaymentNameLabel.text = paymentArray[1].dataName
        secondPaymentAmountLabel.text = numFormatter.string(from: NSNumber(value: paymentArray[1].dataValue))
        secondPaymentPercentageLabel.text = numFormatter.string(from: NSNumber(value: paymentArray[1].dataPercent))! + "%"
        
        thirdPaymentNameLabel.text = paymentArray[2].dataName
        thirdPaymentAmountLabel.text = numFormatter.string(from: NSNumber(value: paymentArray[2].dataValue))
        thirdPaymentPercentageLabel.text = numFormatter.string(from: NSNumber(value: paymentArray[2].dataPercent))! + "%"
        
        forthPaymentNameLabel.text = paymentArray[3].dataName
        forthPaymentAmountLabel.text = numFormatter.string(from: NSNumber(value: paymentArray[3].dataValue))
        forthPaymentPercentageLabel.text = numFormatter.string(from: NSNumber(value: paymentArray[3].dataPercent))! + "%"
        
        fifthPaymentNameLabel.text = paymentArray[4].dataName
        fifthPaymentAmountLabel.text = numFormatter.string(from: NSNumber(value: paymentArray[4].dataValue))
        fifthPaymentPercentageLabel.text = numFormatter.string(from: NSNumber(value: paymentArray[4].dataPercent))! + "%"
    }
    
    @IBAction func getSegue(segue : UIStoryboardSegue) {
        if segue.identifier == "UpdateDate" {
            print("receive")
            self.lastDateO = (segue.source as! dateChooseViewController).fromPicker.date
            self.curDateO = (segue.source as! dateChooseViewController).toPicker.date
            calculateData(curDate: curDateO!, lastDate: lastDateO!)
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SetingDate" {
            if let dvc = segue.destination as? dateChooseViewController {
                dvc.curDate = self.curDateO
                dvc.lastDate = self.lastDateO
                
            }
        }
    }
    

}

extension Date {
    var currentZeroDate: Date {
        let calendar:NSCalendar = NSCalendar.current as NSCalendar
            //calendar.components(NSCalendarUnit(), fromDate: self)//UIntMax
            
        let unitFlags: NSCalendar.Unit = [
                
            NSCalendar.Unit.year,
            NSCalendar.Unit.month,
            NSCalendar.Unit.day,
            .hour,
            .minute,
            .second ]
            
        var components = calendar.components(unitFlags, from: self as Date)

            components.hour = 0
            components.minute = 0
            components.second = 0
            print(" 2  \(components.year)  \(components.month)  \(components.day) \( components.hour)")
        let date = calendar.date(from: components)

        return date!
        }
}
