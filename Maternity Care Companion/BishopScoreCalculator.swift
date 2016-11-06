//
//  BishopScoreCalculator.swift
//  Maternity Care Companion
//
//  Created by Ahmed Zaima on 05/11/2016.
//  Copyright © 2016 Ahmed Zaima. All rights reserved.
//

import UIKit

class BishopScoreCalculator: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var totalScoreLabel: UILabel!
    
    var titlesArray = [["< 1 cm", "1 - 2 cm", "2 - 4 cm"], ["> 4 cm", "2 - 4 cm","1 - 2 cm"],["-3","-2","-1"],["Firm","Medium","Soft"],["Posterior","Mid","Anterior"]]
    
    var scoreArray = Array(repeating: 0, count: 5)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.delegate = self
        pickerView.dataSource = self
        
        updateScoreLabel()
        // Do any additional setup after loading the view.
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return titlesArray[segmentControl.selectedSegmentIndex][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        scoreArray[segmentControl.selectedSegmentIndex] = row
        updateScoreLabel()
    }
    
    @IBAction func segmentSelectedFromSegmentControl(_ sender: Any) {
        
        pickerView.reloadAllComponents()
        pickerView.selectRow(scoreArray[segmentControl.selectedSegmentIndex], inComponent: 0, animated: true)
        
    }

    func updateScoreLabel() {
        var total = 0
        for score in scoreArray {
            total += score
        }
        totalScoreLabel.text = "Total Score: \(total)"
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
