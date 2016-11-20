//
//  ProceduresAndProtocolsDatabase.swift
//  Maternity Care Companion
//
//  Created by Ahmed Zaima on 18/11/2016.
//  Copyright © 2016 Ahmed Zaima. All rights reserved.
//

import Foundation

class ProceduresAndProtocolsDatabase: NSObject, NSCoding {
    
    var date: Date
    var listOfProcedures: [Procedure]?
    var listOfProtocols: [Procedure]?
    
    required init (date: Date, listOfProcedures: [Procedure]?, listOfProtocols: [Procedure]?){
        
        self.date = date
        self.listOfProcedures = listOfProcedures
        self.listOfProtocols = listOfProtocols
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: "Date")
        aCoder.encode(listOfProcedures, forKey: "listOfProcedures")
        aCoder.encode(listOfProtocols, forKey: "listOfProtocols")
    }

    
    func decodeData(with aDecoder: NSCoder) {
        let date = aDecoder.decodeObject(forKey: "Date") as! Date
        let listOfProcedures = aDecoder.decodeObject(forKey: "listOfProcedures") as? [Procedure]
        let listOfProtocols = aDecoder.decodeObject(forKey: "listOfProtools") as? [Procedure]
        
        
        self.date = date
        self.listOfProcedures = listOfProcedures
        self.listOfProtocols = listOfProtocols
    }
    required convenience init?(coder aDecoder: NSCoder) {
        let date = aDecoder.decodeObject(forKey: "Date") as! Date
        let listOfProcedures = aDecoder.decodeObject(forKey: "listOfProcedures") as? [Procedure]
        let listOfProtocols = aDecoder.decodeObject(forKey: "listOfProtools") as? [Procedure]
        
        
        self.init(date: date, listOfProcedures: listOfProcedures, listOfProtocols: listOfProtocols)
    }
    
}
