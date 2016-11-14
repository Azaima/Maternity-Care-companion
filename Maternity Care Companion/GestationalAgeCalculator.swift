//
//  GestationalAgeCalculator.swift
//  Maternity Care Companion
//
//  Created by Ahmed Zaima on 05/11/2016.
//  Copyright © 2016 Ahmed Zaima. All rights reserved.
//

import UIKit

class GestationalAgeCalculator: UIViewController {

    
    @IBOutlet weak var gestationalAgeFromSelector: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var gestationalAgeLAbel: UILabel!
    
    var date = Date()
    var dateFormatter = DateFormatter()
    var intervalFromDate = TimeInterval()
    
    var dateOnPicker: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.sizeToFit()
        gestationalAgeFromSelector.selectedSegmentIndex = 1
        checkDateAndUpdateLabel()
        
    }

    @IBAction func datePickerChanged(_ sender: Any) {
        
        checkDateAndUpdateLabel()
    }
    
    @IBAction func gestationalAgeFromSelectorSelected(_ sender: Any) {
        
        checkDateAndUpdateLabel()
    }
    
    
    func checkDateAndUpdateLabel() {
        dateFormatter.dateFormat = "YYYY/MM/dd"
        let dateToday = dateFormatter.date(from: dateFormatter.string(from: date))
        
        intervalFromDate = datePicker.date.timeIntervalSince(dateToday!)
        
        let intervalInDays = Int(intervalFromDate) / 86400
        switch gestationalAgeFromSelector.selectedSegmentIndex {
        case 0:
            if intervalInDays < 0 && intervalInDays > -301 {
                gestationalAgeLAbel.text = "\(-intervalInDays / 7) Weeks \(-intervalInDays % 7) Days"
            } else {
                gestationalAgeLAbel.text = "Invalid Date"
            }
        case 1:
            if intervalInDays > -21 && intervalInDays < 280 {
                gestationalAgeLAbel.text = "\((280 - intervalInDays) / 7) Weeks and \((280 - intervalInDays) % 7) Days"
            } else {
                gestationalAgeLAbel.text = "Invalid Date"
            }
            
        default:
            if intervalInDays < 0 && intervalInDays > -287 {
                
                gestationalAgeLAbel.text = "\((-intervalInDays + 14) / 7) Weeks and \((-intervalInDays + 14) % 7) Days"
            } else {
                gestationalAgeLAbel.text = "Invalid Date"
            }
        }

    }

    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
