//
//  Procedure.swift
//  Maternity Care Companion
//
//  Created by Ahmed Zaima on 17/11/2016.
//  Copyright © 2016 Ahmed Zaima. All rights reserved.
//

import UIKit
import CloudKit

class Procedure: NSObject, NSCoding {
    
    
    var record: CKRecord!
    var dataBase: CKDatabase!
    
    var procedureName: String!
    var commentsArray = [String]()
    var imagesArray = [UIImage]()
    var linksToImages = [Int]()
    var type: String?
    
    
    init?(record: CKRecord) {
        
        
        self.procedureName = record["Name"] as! String
        self.commentsArray = record["Comments"] as! [String]
        let images = record["Images"] as! [CKAsset]
        self.linksToImages = record["imageLinksForComments"] as! [Int]
        self.type = record["Type"] as? String
        
        for image in images {
            let url = image.fileURL
            let imageData = NSData(contentsOf: url)
            
            imagesArray.append(UIImage(data: imageData as! Data)!)
        }
    }
    
    init?(procedureName: String, commentsArray: [String], imagesArray: [UIImage], linksToImages: [Int]){
        self.procedureName = procedureName
        self.commentsArray = commentsArray
        self.imagesArray = imagesArray
        self.linksToImages = linksToImages
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(procedureName, forKey: "procedureName")
        aCoder.encode(commentsArray, forKey: "commentsArray")
        aCoder.encode(imagesArray, forKey: "imagesArray")
        aCoder.encode(linksToImages, forKey: "linksToImages")
    }
    
    required init?(coder aDecoder: NSCoder) {
        let procedureName = aDecoder.decodeObject(forKey: "procedureName") as! String
        let commentsArray = aDecoder.decodeObject(forKey: "commentsArray") as! [String]
        let imagesArray = aDecoder.decodeObject(forKey: "imagesArray") as! [UIImage]
        let linksToImages = aDecoder.decodeObject(forKey: "linksToImages") as! [Int]
        
        self.procedureName = procedureName
        self.commentsArray = commentsArray
        self.imagesArray = imagesArray
        self.linksToImages = linksToImages
    }
}
