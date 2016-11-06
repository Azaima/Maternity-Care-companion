//
//  WeightConverter.swift
//  Maternity Care Companion
//
//  Created by Ahmed Zaima on 05/11/2016.
//  Copyright © 2016 Ahmed Zaima. All rights reserved.
//

import UIKit

class WeightConverter: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var maternalNeonatalSelector: UISegmentedControl!
    
    @IBOutlet weak var metricWeightLabel: UILabel!
    @IBOutlet weak var metricWeightPicker: UIPickerView!
    @IBOutlet weak var britishWeightLabel: UILabel!
    @IBOutlet weak var britishWeightPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        metricWeightPicker.delegate = self
        metricWeightPicker.dataSource = self
        britishWeightPicker.delegate = self
        britishWeightPicker.dataSource = self

        metricWeightPicker.selectRow(49, inComponent: 0, animated: true)
        pickerView(metricWeightPicker, didSelectRow: 49, inComponent: 0)
        categorySelected(metricWeightPicker)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch maternalNeonatalSelector.selectedSegmentIndex {
        case 0:
            switch pickerView {
            case metricWeightPicker:
                return 1
            default:
                return 2
            }
        default:
            switch pickerView {
            case metricWeightPicker:
                return 4
            default:
                return 2
            }
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch maternalNeonatalSelector.selectedSegmentIndex {
        case 0:
            switch pickerView {
            case metricWeightPicker:
                return 200
            default:
                switch component {
                case 0:
                    return 31
                default:
                    return 14
                }
            }
        default:
            switch pickerView {
            case metricWeightPicker:
                return 10
            default:
                switch component {
                case 0:
                    return 22
                default:
                    return 16
                }
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch maternalNeonatalSelector.selectedSegmentIndex {
        case 0:
            switch pickerView {
            case metricWeightPicker:
                return "\(row)"
            default:
                switch component {
                case 0:
                    return "\(row)"
                default:
                    return "\(row)"
                }
            }
        default:
            return "\(row)"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var kilograms: Int
        var gramsThousands:Int
        var gramsHundreds: Int
        var gramsTens: Int
        var grams: Int
        var stones: Int
        var pounds: Int
        var ounces: Int
        
        let stoneToKilo = 6350
        let poundToKilo = 454
        let ounceToKilo = 28
        
        switch maternalNeonatalSelector.selectedSegmentIndex {
        case 0:
            switch pickerView {
            case metricWeightPicker:
                kilograms = row
                stones = kilograms * 1000 / stoneToKilo
                pounds = (kilograms  * 1000 % stoneToKilo) / poundToKilo
                
                britishWeightPicker.selectRow(stones, inComponent: 0, animated: true)
                britishWeightPicker.selectRow(pounds, inComponent: 1, animated: true)
            default:
                stones = britishWeightPicker.selectedRow(inComponent: 0)
                pounds = britishWeightPicker.selectedRow(inComponent: 1)
                kilograms = ((stones * stoneToKilo) + (pounds * poundToKilo)) / 1000
                metricWeightPicker.selectRow(kilograms, inComponent: 0, animated: true)
            }
        default:
            switch pickerView {
            case metricWeightPicker:
                gramsThousands = metricWeightPicker.selectedRow(inComponent: 0)
                gramsHundreds = metricWeightPicker.selectedRow(inComponent: 1)
                gramsTens = metricWeightPicker.selectedRow(inComponent: 2)
                grams = metricWeightPicker.selectedRow(inComponent: 3)
                kilograms = gramsThousands * 1000 + gramsHundreds * 100 + gramsTens * 10 + grams
                pounds = kilograms / poundToKilo
                ounces = (kilograms % poundToKilo) / ounceToKilo
                
                britishWeightPicker.selectRow(pounds, inComponent: 0, animated: true)
                britishWeightPicker.selectRow(ounces, inComponent: 1, animated: true)
                
            default:
                pounds = britishWeightPicker.selectedRow(inComponent: 0)
                ounces = britishWeightPicker.selectedRow(inComponent: 1)
                
                kilograms = pounds * poundToKilo + ounces * ounceToKilo
                gramsThousands = kilograms / 1000
                kilograms = kilograms % 1000
                gramsHundreds = kilograms / 100
                kilograms = kilograms % 100
                gramsTens = kilograms / 10
                kilograms = kilograms % 10
                grams = kilograms
                
                metricWeightPicker.selectRow(gramsThousands, inComponent: 0, animated: true)
                metricWeightPicker.selectRow(gramsHundreds, inComponent: 1, animated: true)
                metricWeightPicker.selectRow(gramsTens, inComponent: 2, animated: true)
                metricWeightPicker.selectRow(grams, inComponent: 3, animated: true)
            }
        }
    }
    
    
    
    @IBAction func categorySelected(_ sender: Any) {
        metricWeightPicker.reloadAllComponents()
        britishWeightPicker.reloadAllComponents()
        
        switch maternalNeonatalSelector.selectedSegmentIndex {
        case 0:
            metricWeightLabel.text = "Kilograms"
            britishWeightLabel.text = "Stones \t\t Pounds"
        default:
            metricWeightLabel.text = "Grams"
            britishWeightLabel.text = "Pounds \t\t Ounces"
        }
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
