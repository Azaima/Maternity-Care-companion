//
//  ProceduresAndProtocols.swift
//  Maternity Care Companion
//
//  Created by Ahmed Zaima on 14/11/2016.
//  Copyright © 2016 Ahmed Zaima. All rights reserved.
//

import UIKit
import CloudKit

class ProceduresAndProtocols: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var listOfProceduresAndProtocols = [[Procedure]]() {
        
        didSet {
            proceduresAndProtocolsTable.reloadData()
            
        }
    }
    
    let iCloudContainer = CKContainer.default()
    var publicDataBase: CKDatabase!
    
    var dataBase: ProceduresAndProtocolsDatabase?
    var recordResults = [CKRecord]()
    
    var dateOfUpdateOnSystem: Date?
    var dateOnICloud: Date? {
        didSet{
            checkIfUpdateRequired()
        }
    }
    
    var alert: AlertView!
    
    var alertView = UIView()

    @IBOutlet weak var alertMessageStack: UIStackView!
    @IBOutlet weak var alertMessageLabel: UILabel!
    
    @IBOutlet weak var darkenBackGround: UIView!
    @IBOutlet weak var proceduresAndProtocolsTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        proceduresAndProtocolsTable.delegate = self
        proceduresAndProtocolsTable.dataSource = self
        
        publicDataBase = iCloudContainer.publicCloudDatabase
        
        
        
        listOfProceduresAndProtocols = loadDataFromSystem()
        fetchLastUpdateDate()
           }

    // MARK: Load Data from the system
    
    func loadDataFromSystem() -> [[Procedure]]{
        
        let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first
        let archiveURL = documentsDirectory?.appendingPathComponent("MaternityCareCompanion")
        
        var listOfProcedures = [Procedure]()
        var listOfProtocols = [Procedure]()
        
        if let savedDatabaseDictionary = NSKeyedUnarchiver.unarchiveObject(withFile: (archiveURL?.path)!) as? [String: Any] {
            let date = savedDatabaseDictionary["Date"] as! Date
            var listOfProceduresStored = [Procedure]()
            var listOfProtocolsStored = [Procedure]()
            
            for procedureDictionary in savedDatabaseDictionary["Procedures"] as! [[String: Any]] {
                let procedureName = procedureDictionary["procedureName"]
                let commentsArray = procedureDictionary["commentsArray"]
                let imagesArray = procedureDictionary["imagesArray"]
                let linksToImages = procedureDictionary["linksToImages"]
                
                let procedure = Procedure(procedureName: procedureName as! String, commentsArray: commentsArray as! [String], imagesArray: imagesArray as! [UIImage], linksToImages: linksToImages as! [Int])
                listOfProceduresStored.append(procedure!)
                
            }
            
            for procedureDictionary in savedDatabaseDictionary["Protocols"] as! [[String: Any]] {
                let procedureName = procedureDictionary["procedureName"]
                let commentsArray = procedureDictionary["commentsArray"]
                let imagesArray = procedureDictionary["imagesArray"]
                let linksToImages = procedureDictionary["linksToImages"]
                
                let procedure = Procedure(procedureName: procedureName as! String, commentsArray: commentsArray as! [String], imagesArray: imagesArray as! [UIImage], linksToImages: linksToImages as! [Int])
                listOfProtocolsStored.append(procedure!)
                
            }
            
            
            let savedDatabase = ProceduresAndProtocolsDatabase(date: date, listOfProcedures: listOfProceduresStored, listOfProtocols: listOfProtocolsStored)
            
            
            dataBase = savedDatabase
            
            
            if dataBase?.listOfProcedures != nil{
                listOfProcedures = (dataBase?.listOfProcedures!)!
                
            }
            if dataBase?.listOfProtocols != nil {
                listOfProtocols = (dataBase?.listOfProtocols!)!
                
            }
            dateOfUpdateOnSystem = savedDatabase.date
            
            
        }
        
        return [listOfProcedures,listOfProtocols]
    }
    
    // MARK: iCloud Management
    // Fetch Date from iCloud
    
    func fetchLastUpdateDate(){
        let query = CKQuery(recordType: "DateOFLastUpdate", predicate: NSPredicate(value: true))
        
        
        publicDataBase.perform(query, inZoneWith: nil, completionHandler: {dateOFLastUpdate, error in
            
            
            
            guard error == nil else {
                DispatchQueue.main.async {
                    
                    self.errorAccessingICloud(message: "To access 'Procedures and Protocols' you must be signed to iCloud and have iCloud Drive enabled")
                }
                return
            }
            
            DispatchQueue.main.async {
                self.dateOnICloud = dateOFLastUpdate?[0]["Date"] as? Date
            }
            
        })
        
    }
    
    // Get DataBase From iCloud
    
    func getDataFromICloud(){
        
        let query = CKQuery(recordType: "Procedure", predicate: NSPredicate(value: true))
        var listOfProcedures = [Procedure]()
        var listOfProtocols = [Procedure]()
        
        publicDataBase.perform(query, inZoneWith: nil, completionHandler: {records, error in
            
            
            guard error == nil else {
                
                DispatchQueue.main.async {
                    self.errorAccessingICloud(message: "Database Update Failed")
                }
                return
            }
            
            
            DispatchQueue.main.async {
                for procedureRecord in records!{
                    
                    let procedure = Procedure(record: procedureRecord)
                    
                    if procedure?.type == "Procedure"{
                        listOfProcedures.append(procedure!)
                    }   else {
                        listOfProtocols.append(procedure!)
                    }
                }
                
                self.listOfProceduresAndProtocols = [listOfProcedures,listOfProtocols]
                
                self.updateDatabase()
               
            }
        })
        
    }

    
    // Check if Update Required
    
    func checkIfUpdateRequired(){
        
        if  dateOfUpdateOnSystem != nil {
            var timeIntervalSinceUpdate = TimeInterval()
            timeIntervalSinceUpdate = (dateOfUpdateOnSystem?.timeIntervalSince(dateOnICloud!))!
            if timeIntervalSinceUpdate < 0 {
                
                getDataFromICloud()
            }
        } else {
            
            getDataFromICloud()
        }
    }

    // Update DataBase
    
    func updateDatabase(){
        let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first
        let archiveURL =  documentsDirectory?.appendingPathComponent("MaternityCareCompanion")
        
        self.dataBase = ProceduresAndProtocolsDatabase(date: dateOnICloud!, listOfProcedures: listOfProceduresAndProtocols[0], listOfProtocols: listOfProceduresAndProtocols[1])
        
        var dataBaseDictionary = [String: Any]()
        dataBaseDictionary["Date"] = dataBase?.date
        
        var arrayOfProcedureDictionaries = [[String: Any]]()
        for procedure in (dataBase?.listOfProcedures)! {
            var procedureDictionary = [String: Any]()
            procedureDictionary["procedureName"] = procedure.procedureName
            procedureDictionary["commentsArray"] = procedure.commentsArray
            procedureDictionary["imagesArray"] = procedure.imagesArray
            procedureDictionary["linksToImages"] = procedure.linksToImages
            
            arrayOfProcedureDictionaries.append(procedureDictionary)
            
        }
        
        var arrayOfProtocolDictionaries = [[String: Any]]()
        for procedure in (dataBase?.listOfProtocols)! {
            var protocolDictionary = [String: Any]()
            protocolDictionary["procedureName"] = procedure.procedureName
            protocolDictionary["commentsArray"] = procedure.commentsArray
            protocolDictionary["imagesArray"] = procedure.imagesArray
            protocolDictionary["linksToImages"] = procedure.linksToImages
            
            arrayOfProtocolDictionaries.append(protocolDictionary)
            
        }
        
        dataBaseDictionary["Procedures"] = arrayOfProcedureDictionaries
        dataBaseDictionary["Protocols"] = arrayOfProtocolDictionaries
        
        let successfulSave = NSKeyedArchiver.archiveRootObject(dataBaseDictionary, toFile: (archiveURL?.path)!)
        if successfulSave {
            
            errorAccessingICloud(message: "Database Successfully Updated")
        }
        
        
    }

    
    
    // MARK: Setup Table
    
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
        
    // MARK: Error Message
        
    func errorAccessingICloud(message: String) {

        alert = AlertView(frame: self.view.frame, message: message, withAction: "Dismiss")
        view.addSubview(alert)
        
    }
  
    
}
