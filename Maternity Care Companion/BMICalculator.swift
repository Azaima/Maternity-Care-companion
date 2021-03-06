//
//  BMICalculator.swift
//  Maternity Care Companion
//
//  Created by Ahmed Zaima on 05/11/2016.
//  Copyright © 2016 Ahmed Zaima. All rights reserved.
//

import UIKit

class BMICalculator: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var weightAndHeightPickeer: UIPickerView!
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var bsaLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        weightAndHeightPickeer.delegate = self
        weightAndHeightPickeer.dataSource = self
        
        weightAndHeightPickeer.selectRow(25, inComponent: 0, animated: true)
        weightAndHeightPickeer.selectRow(50, inComponent: 1, animated: true)
        
        updateBMILabel()
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 170
        }   else {
            return 100
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(30 + row)"
        }   else {
            return "\(100 + row)"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateBMILabel()
    }
    
    func updateBMILabel() {
        
        var bsa: Double
        var bmi: Double
        var weight: Double
        var height: Double
        
        weight = Double(weightAndHeightPickeer.selectedRow(inComponent: 0) + 30)
        height = Double(weightAndHeightPickeer.selectedRow(inComponent: 1) + 100) / 100
        bmi = weight / pow(height , 2)
        bsa = 0.007184 * pow(weight, 0.425) * pow((height * 100), 0.725)
        
        bmi = Double(Int(bmi * 10)) / 10
        bsa = Double(Int(bsa * 100)) / 100
        
        bmiLabel.text = "BMI = \(bmi)"
        bsaLabel.text = "BSA = \(bsa)"
        
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
   
}
