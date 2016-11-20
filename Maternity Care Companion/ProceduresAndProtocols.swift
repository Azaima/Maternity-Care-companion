//
//  ProceduresAndProtocols.swift
//  Maternity Care Companion
//
//  Created by Ahmed Zaima on 14/11/2016.
//  Copyright © 2016 Ahmed Zaima. All rights reserved.
//

import UIKit

class ProceduresAndProtocols: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var listOfProceduresAndProtocols = [[Procedure]]()
    
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
        if listOfProceduresAndProtocols.isEmpty{
            return 0
        }   else {
            if listOfProceduresAndProtocols[section].isEmpty{
                return 1
            } else {
                return listOfProceduresAndProtocols[section].count
            }
        }
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
        if listOfProceduresAndProtocols[indexPath.section].isEmpty {
            cell?.textLabel?.text = "None Listed"
        } else {
            cell?.textLabel?.text = listOfProceduresAndProtocols[indexPath.section][indexPath.row].procedureName
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !listOfProceduresAndProtocols[indexPath.section].isEmpty {
            performSegue(withIdentifier: "ShowProcedureVC", sender: proceduresAndProtocolsTable.indexPathForSelectedRow)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowProcedureVC" {
            let destination = segue.destination as! ShowProcedureVC
            
            destination.procedure = listOfProceduresAndProtocols[(sender as! IndexPath).section][(sender as! IndexPath).row]
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
  
}
