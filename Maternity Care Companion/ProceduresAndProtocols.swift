//
//  ProceduresAndProtocols.swift
//  Maternity Care Companion
//
//  Created by Ahmed Zaima on 14/11/2016.
//  Copyright © 2016 Ahmed Zaima. All rights reserved.
//

import UIKit

class ProceduresAndProtocols: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var listOfProceduresAndProtocols = [[String](),["Shoulder Dystocia"]]
    let listOfProcedureSteps = [[(String, UIImage?)](),[("Call for HELP", nil),("Discourage Pushing\rLie flat\rMove Buttocks to edge of Bed", nil), ("McRoberts' Manoeuvre", #imageLiteral(resourceName: "McRoberts")),("Suprapubic Pressure", #imageLiteral(resourceName: "SuprapubicPressure")), ("Consider episiotomy if it will make internal manoeuvres easier",nil), ("Deliver posterior arm", #imageLiteral(resourceName: "posteriorArm_1")), ("Deliver posterior arm", #imageLiteral(resourceName: "posteriorArm_2")), ("Deliver posterior arm", #imageLiteral(resourceName: "posteriorArm_3")), ("Deliver posterior arm", #imageLiteral(resourceName: "posteriorArm_4")), ("Alternatively\rPerform Internal Rotation Manoeuvres", #imageLiteral(resourceName: "internalRotation_1")), ("Repeat Manoeuvres in ALL Fours", nil), ("Consider:\r Cleidotomy\rZavanelli Manoeuvre\rSymphysiotomy", nil)]] as [[(String, UIImage?)]]
    
    @IBOutlet weak var proceduresAndProtocolsTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        proceduresAndProtocolsTable.delegate = self
        proceduresAndProtocolsTable.dataSource = self
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfProceduresAndProtocols[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Procedures"
        }   else {
            return "Protocols"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProceduresAndProtocolsCell") as UITableViewCell!
        cell?.textLabel?.textAlignment = .center
        cell?.textLabel?.text = listOfProceduresAndProtocols[indexPath.section][indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowProcedureVC", sender: proceduresAndProtocolsTable.indexPathForSelectedRow)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowProcedureVC" {
            let destination = segue.destination as! ShowProcedureVC
            destination.stepsArray = listOfProcedureSteps[(sender as! IndexPath).section]
            destination.header = listOfProceduresAndProtocols[(sender as! IndexPath).section][(sender as! IndexPath).row]
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
  
}
