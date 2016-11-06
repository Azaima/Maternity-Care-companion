//
//  BloodResultsRanges.swift
//  Maternity Care Companion
//
//  Created by Ahmed Zaima on 06/11/2016.
//  Copyright © 2016 Ahmed Zaima. All rights reserved.
//

import UIKit

class BloodResultsRanges: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableOfResultsRanges: UITableView!
    
    
    var listToBePresented = [["Hb g/L", "120 – 150", "110 – 140", "", "", ""],    ["WBC x 10^9/L", "4 – 11", "6-16", "", "", ""],     ["Platelets x 109/L", "150 – 400", "150 – 400", "", "", ""],    ["MCV fL", "80 – 100", "80 – 100", "", "", ""],     ["CRP g/L","0 – 7", "0 – 7", "", "", ""],     ["Urea mmol/L", "2.5 – 7.5","","2.8 – 4.2", "2.5 – 4.1", "2.4 – 3.8"],     ["Creatinine µmol/L", "65 – 101", "", "52 – 68", "44 – 64", "55 – 73"],     ["K mmol/L", "3.5 – 5.0", "3.3 – 4.1","","",""],     ["Na mmol/L","135 – 145", "130 – 140","","",""],     ["Uric Acid mmol/L", "0.18 - 0.35","", "0.14 – 0.23", "0.14 – 0.29", "0.21 – 0.38"],    ["24-hour protein g", "<0.15", "<0.3", "", "", ""],     ["24-hour creatinine Clearance","70 – 140","","140 – 162","139 – 169","119 – 139"],     ["Bilirubin µmol/L", "0 – 17", "", "4 – 16","3 – 13" , "3 – 14"],     ["Total protein g/L", "64 – 86", "48 – 64", "", "", ""],     ["Albumin g/L", "34 – 46", "28 – 37", "", "", ""],     ["AST IU/L", "7 – 40", "", "10 – 28", "11 – 29", "11 – 30"],     ["ALT IU/L", "0 – 40", "6 – 32", "", "", ""],    ["GGT IU/L","11 – 50", "", "5 – 37", "5 – 43","3 – 41"],    ["ALP IU/L", "30 – 130", "", "32 – 100","43 – 135", "133 – 418"],    ["Bile Acids µmol/L", "0 – 14", "0 – 14", "", "", ""],     ["fT4 pmol/L", "11 – 23", "", "11 – 22", "11 – 19", "7 – 15"],     ["fT3 pmol/L","4 - 9", "", "4 - 8", "4 – 7", "3 – 5"],    ["TSH mu/L", "0 – 4", "", "0 – 1.6", " 0.1 – 1.8", "0.7 – 7.3"]]

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableOfResultsRanges.delegate = self
        tableOfResultsRanges.dataSource = self
        
        tableOfResultsRanges.reloadData()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listToBePresented.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BloodResultsTableCell") as! BloodResultsTableCell
        
        
        cell.label1.text = listToBePresented[indexPath.row][0]
        cell.label2.text = listToBePresented[indexPath.row][1]
        cell.label3.text = listToBePresented[indexPath.row][2]
        cell.label4.text = listToBePresented[indexPath.row][3]
        cell.label5.text = listToBePresented[indexPath.row][4]
        cell.label6.text = listToBePresented[indexPath.row][5]
        
        return cell
    }
    

    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
   
}
