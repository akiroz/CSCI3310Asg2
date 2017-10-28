//
//  BlossomRecord.swift
//  CSCI_3310_Asg2
//
//  Created by me on 26/10/2017.
//  Copyright © 2017 myself. All rights reserved.
//


import UIKit


//  MARK :- Constants
let recordURL = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
let recordPath = recordURL.appendingPathComponent("BlossomRecord").path


class BlossomRecord: NSObject, NSCoding {
    
    static var recordArray: [BlossomRecord]?
    
    var recordName: String!
    var locName: String!
    var isFavorite: Bool!
    var recordImage: UIImage!
    var recordImageName: String!
    
    init(recordName: String! = "", locName: String! = "", isFavorite: Bool! = false, recordImage: UIImage! = UIImage(named: "img_no_photo.png") , recordImageName: String! = "img_no_photo.png") {
        self.recordName = recordName
        self.locName = locName
        self.isFavorite = isFavorite
        self.recordImage = recordImage
        self.recordImageName = recordImageName
    }
    
    // MARK :- NSCoding
    
    required init?(coder aDecoder: NSCoder) {
        self.recordName = aDecoder.decodeObject(forKey: "recordName") as! String
        self.locName = aDecoder.decodeObject(forKey: "locName") as! String
        self.isFavorite = aDecoder.decodeObject(forKey: "isFavorite") as! Bool
        self.recordImageName = aDecoder.decodeObject(forKey: "recordImageName") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(recordName, forKey: "recordName")
        aCoder.encode(locName, forKey: "locName")
        aCoder.encode(isFavorite, forKey: "isFavorite")
        aCoder.encode(recordImageName, forKey: "recordImageName")
    }
    
    
    
    class func loadRecordFromLocal() {
        recordArray = NSKeyedUnarchiver.unarchiveObject(withFile: recordPath) as? [BlossomRecord] ?? []
        
        for record in BlossomRecord.recordArray ?? [] {
            
//            #if DEBUG
//                print(record.recordName)
//                print(record.locName)
//                print(record.recordImageName)
//            #endif
//
            record.loadImageFromLocal(imageName: record.recordImageName ?? "")
        }
    }
    
    class func saveRecordToLocal() {
        
//        for record in BlossomRecord.recordArray ?? [] {
//            #if DEBUG
//                print(record.recordName)
//                print(record.locName)
//                print(record.recordImageName)
//            #endif
//        }
        if NSKeyedArchiver.archiveRootObject(recordArray!, toFile: recordPath) == true {
            
            for record in BlossomRecord.recordArray ?? [] {
                record.saveImageToLocal(image: record.recordImage, imageName: record.recordImageName)
            }
            
            #if DEBUG
                print("Save Successfully.")
            #endif
        } else {
            #if DEBUG
                print("Save Failed.")
            #endif
        }
        
        
        
        
        
    }
    
    func loadImageFromLocal(imageName recordImageName: String) {
        let imagePath = recordURL.appendingPathComponent(recordImageName.replacingOccurrences(of: "/", with: "-")).path
        
        if FileManager.default.fileExists(atPath: imagePath) {
            self.recordImage = UIImage(contentsOfFile: imagePath)
        }
    }
    
    func saveImageToLocal(image recordImage: UIImage!, imageName recordImageName: String) {
        let imageSavingURL = recordURL.appendingPathComponent(recordImageName.replacingOccurrences(of: "/", with: "-"))
        
        if let pngImageData = UIImagePNGRepresentation(recordImage!) {
            do {
                try pngImageData.write(to: imageSavingURL, options: .atomic)
            } catch { }
        }

        
    }
    
    
    
}
