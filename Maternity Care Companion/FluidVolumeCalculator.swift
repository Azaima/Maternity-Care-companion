//
//  FluidVolumeCalculator.swift
//  Maternity Care Companion
//
//  Created by Ahmed Zaima on 09/11/2016.
//  Copyright © 2016 Ahmed Zaima. All rights reserved.
//

import UIKit

class FluidVolumeCalculator: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var fluidInLabel: UILabel!
    @IBOutlet weak var fluidOutLabel: UILabel!
    @IBOutlet weak var fluidBalanceLAbel: UILabel!
    @IBOutlet weak var fluidBalanceScrollView: UIScrollView!
    
    var listOfVolumeInTextfields = [UITextField]()
    var listofVolumeOutTextFields = [UITextField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupScrollView()
    }

    //MARK: scroll view setup
   
    func setupScrollView(){
        
        fluidBalanceScrollView.contentSize.height = 960
        
        for index in 0 ..< 24 {
            
            let label = UILabel(frame: CGRect(x: 0, y: index * 40, width: 50, height: 40))
            label.adjustsFontSizeToFitWidth = true
            label.text = index > 9 ? "\(index):00" : "0\(index):00"
            label.textAlignment = .center
            
            
            let textfieldWidth = Int(fluidBalanceScrollView.frame.size.width - 62) / 2
            
            let volumeInTextfield = UITextField(frame: CGRect(x: 58, y: index * 40 + 5, width: textfieldWidth, height: 30))
            volumeInTextfield.layer.cornerRadius = 5
            volumeInTextfield.clipsToBounds = true
            volumeInTextfield.backgroundColor = UIColor.white
            volumeInTextfield.textAlignment = .center
            volumeInTextfield.layer.borderWidth = 1
            volumeInTextfield.layer.borderColor = UIColor.lightGray.cgColor
            
            let volumeOutTextfield = UITextField(frame: CGRect(x: 66 + textfieldWidth, y: index * 40 + 5, width: textfieldWidth, height: 30))
            volumeOutTextfield.layer.cornerRadius = 5
            volumeOutTextfield.clipsToBounds = true
            volumeOutTextfield.backgroundColor = UIColor.white
            volumeOutTextfield.textAlignment = .center
            volumeOutTextfield.layer.borderWidth = 1
            volumeOutTextfield.layer.borderColor = UIColor.lightGray.cgColor
            
            listOfVolumeInTextfields.append(volumeInTextfield)
            listofVolumeOutTextFields.append(volumeOutTextfield)
            
            volumeInTextfield.delegate = self
            volumeOutTextfield.delegate = self
            
            fluidBalanceScrollView.addSubview(label)
            fluidBalanceScrollView.addSubview(volumeInTextfield)
            fluidBalanceScrollView.addSubview(volumeOutTextfield)
            
        }
        
    }
    
    // MARK: Textfield management
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkTextField(textField: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        checkTextField(textField: textField)
        
        return true
    }
    
    func checkTextField(textField: UITextField) {
        if Int(textField.text!) != nil {
            var totalIn = 0
            var totalOut = 0
            
            for volumeInEntry in listOfVolumeInTextfields {
                if Int(volumeInEntry.text!) != nil {
                    totalIn += Int(volumeInEntry.text!)!
                }
            }
            
            for volumeOutEntry in listofVolumeOutTextFields {
                if Int(volumeOutEntry.text!) != nil {
                    totalOut += Int(volumeOutEntry.text!)!
                }
            }
            
            fluidInLabel.text = "Total in: \(totalIn)"
            fluidOutLabel.text = "Total out: \(totalOut)"
            let fluidBalance = totalIn - totalOut > 0 ? "Fluid Balance: +\(totalIn - totalOut)" : "Fluid Balance: \(totalIn - totalOut)"
            fluidBalanceLAbel.text = fluidBalance
            
        }   else {
            textField.text = ""
        }

    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


}
