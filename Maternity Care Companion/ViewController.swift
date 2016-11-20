//
//  ViewController.swift
//  Maternity Care Companion
//
//  Created by Ahmed Zaima on 05/11/2016.
//  Copyright © 2016 Ahmed Zaima. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController {

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
    
    var listOfProceduresAndProtocols = [[Procedure]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        publicDataBase = iCloudContainer.publicCloudDatabase
        fetchLastUpdateDate()
        listOfProceduresAndProtocols = loadDataFromSystem()
        
    }

    
    
    func fetchLastUpdateDate(){
        let query = CKQuery(recordType: "DateOFLastUpdate", predicate: NSPredicate(value: true))
        
        publicDataBase.perform(query, inZoneWith: nil, completionHandler: {lastUpdateDateRecord, error in
            
            if error != nil {
                let err = CKError(_nsError: error as! NSError)

                if err.errorCode == 1 {
                    self.errorAccessingICloud(message: "To access 'Procedures and Protocols' you must be signed to iCloud and have iCloud Drive enabled")
                }
                
                
            } else {
                
                self.dateOnICloud = lastUpdateDateRecord?[0]["Date"] as? Date
            }
        })
    
    }
    
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
    
    func getDataFromICloud(){
        
        let query = CKQuery(recordType: "Procedure", predicate: NSPredicate(value: true))
        var listOfProcedures = [Procedure]()
        var listOfProtocols = [Procedure]()
        
        publicDataBase.perform(query, inZoneWith: nil, completionHandler: {records, error in
            if error == nil {
                
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProceduresAndProtocols"{
            let destination = segue.destination as! ProceduresAndProtocols
            destination.listOfProceduresAndProtocols = listOfProceduresAndProtocols
        }
    }
    
    func errorAccessingICloud(message: String) {
        // Replace this stub.
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
}

