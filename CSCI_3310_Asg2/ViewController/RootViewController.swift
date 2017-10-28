//
//  RootViewController.swift
//  CSCI_3310_Asg2
//
//  Created by me on 25/10/2017.
//  Copyright © 2017 myself. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var favouriteSwitch: UISwitch!
    @IBOutlet weak var byNameButton: UIButton!
    @IBOutlet weak var byLocButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var onlyFavorite: Bool! = false
    var sortedByName: Bool! = false
    var sortedByLoc: Bool! = false
    
    var favoriteRecordArray: [BlossomRecord]?
    
    
    @IBAction func switchTriggered(_ sender: UISwitch) {
        if sender.isOn == true {
            onlyFavorite = true
        } else {
            onlyFavorite = false
        }
        tableView.reloadData()
    }
    
    @IBAction func editButtonTriggered(_ sender: UIBarButtonItem) {
        
        if tableView.isEditing == false {
            tableView.isEditing = true
            editButton.title = "Done"
            editButton.setTitleTextAttributes([
                NSAttributedStringKey.font : UIFont(name: "Helvetica-Bold", size: UIFont.buttonFontSize)!
                ], for: .normal)
            
        } else {
            tableView.isEditing = false
            editButton.title = "Edit"
            editButton.setTitleTextAttributes([
                NSAttributedStringKey.font : UIFont(name: "Helvetica", size: UIFont.buttonFontSize)!
                ], for: .normal)
        }
        
    }
    @IBAction func byNameButtonTriggered(_ sender: UIButton) {
        sortedByName = true
        sortedByLoc = false
        byNameButton.setTitleColor(UIColor(red: 0, green: 0, blue: 120/255, alpha: 1.0), for: .normal)
        byLocButton.setTitleColor(UIColor.lightGray, for: .normal)
        tableView.reloadData()
    }
    
    @IBAction func byLocButtonTriggered(_ sender: UIButton) {
        sortedByName = false
        sortedByLoc = true
        byNameButton.setTitleColor(UIColor.lightGray, for: .normal)
        byLocButton.setTitleColor(UIColor(red: 0, green: 0, blue: 120/255, alpha: 1.0), for: .normal)
        tableView.reloadData()
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        recordInit()
        
        tableView.register(UINib(nibName: "CustomTableCell", bundle: nil), forCellReuseIdentifier: "CustomTableCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        updateFavoriteRecordArray()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    
    
    func recordInit() {
        
        BlossomRecord.loadRecordFromLocal()

        if BlossomRecord.recordArray != nil && BlossomRecord.recordArray! != [] {
            #if DEBUG
                print("Loaded.")
            #endif
            return
        }
        
        let record1 = BlossomRecord()
        let record2 = BlossomRecord()
        let record3 = BlossomRecord()
        let record4 = BlossomRecord()
        
        record1.recordName = "Rose"
        record1.locName = "Tin Ka Ping Building"
        record1.isFavorite = false
        record1.recordImage = UIImage(named: "photo_rose.jpg")
        record1.recordImageName = "photo_rose.jpg"
        BlossomRecord.recordArray?.append(record1)
        
        record2.recordName = "Orange Trumpet"
        record2.locName = "Lee Shau Kee Building"
        record2.isFavorite = true
        record2.recordImage = UIImage(named: "photo_orange_trumpet.jpg")
        record2.recordImageName = "photo_orange_trumpet.jpg"
        BlossomRecord.recordArray?.append(record2)
        
        record3.recordName = "Bougainvillea"
        record3.locName = "Sir Run Run Shaw Hall"
        record3.isFavorite = false
        record3.recordImage = UIImage(named: "photo_bougainvillea.jpg")
        record3.recordImageName = "photo_bougainvillea.jpg"
        BlossomRecord.recordArray?.append(record3)

        record4.recordName = "Cherry Blossom"
        record4.locName = "Chih Hsing Hall, NA"
        record4.isFavorite = true
        record4.recordImage = UIImage(named: "photo_cherry_blossom.jpg")
        record4.recordImageName = "photo_cherry_blossom.jpg"
        BlossomRecord.recordArray?.append(record4)
        
        BlossomRecord.saveRecordToLocal()
        
        #if DEBUG
            print("Init completed.")
        #endif
    
    }
    
    func updateFavoriteRecordArray() {
        favoriteRecordArray = BlossomRecord.recordArray?.filter({ (record) -> Bool in
            if record.isFavorite == true {
                return true
            }
            return false
        })
    }
    
    
    //  MARK :- UITableViewDelegate, UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if onlyFavorite == true {
            return favoriteRecordArray?.count ?? 0
        }
        return BlossomRecord.recordArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 4.5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableCell", for: indexPath) as? CustomTableCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("CustomTableCell", owner: self, options: nil)?[0] as? CustomTableCell
        }

        if onlyFavorite == true {
            if sortedByName == true {
                cell!.nameLabel.text = favoriteRecordArray?.sorted(by: {$0.recordName < $1.recordName})[indexPath.row].recordName
                cell!.locLabel.text = favoriteRecordArray?.sorted(by: {$0.recordName < $1.recordName})[indexPath.row].locName
                cell!.starImageView.image = favoriteRecordArray?.sorted(by: {$0.recordName < $1.recordName})[indexPath.row].isFavorite == true ? UIImage(named: "img_star_filled.png") : UIImage(named: "img_star_empty.png")
                cell!.recordImageView.image = favoriteRecordArray?.sorted(by: {$0.recordName < $1.recordName})[indexPath.row].recordImage
            } else if sortedByLoc == true {
                cell!.nameLabel.text = favoriteRecordArray?.sorted(by: {$0.locName < $1.locName})[indexPath.row].recordName
                cell!.locLabel.text = favoriteRecordArray?.sorted(by: {$0.locName < $1.locName})[indexPath.row].locName
                cell!.starImageView.image = favoriteRecordArray?.sorted(by: {$0.locName < $1.locName})[indexPath.row].isFavorite == true ? UIImage(named: "img_star_filled.png") : UIImage(named: "img_star_empty.png")
                cell!.recordImageView.image = favoriteRecordArray?.sorted(by: {$0.locName < $1.locName})[indexPath.row].recordImage
            } else {
                cell!.nameLabel.text = favoriteRecordArray?[indexPath.row].recordName
                cell!.locLabel.text = favoriteRecordArray?[indexPath.row].locName
                cell!.starImageView.image = favoriteRecordArray?[indexPath.row].isFavorite == true ? UIImage(named: "img_star_filled.png") : UIImage(named: "img_star_empty.png")
                cell!.recordImageView.image = favoriteRecordArray?[indexPath.row].recordImage
            }
        } else {
            if sortedByName == true {
                cell!.nameLabel.text = BlossomRecord.recordArray?.sorted(by: {$0.recordName < $1.recordName})[indexPath.row].recordName
                cell!.locLabel.text = BlossomRecord.recordArray?.sorted(by: {$0.recordName < $1.recordName})[indexPath.row].locName
                cell!.starImageView.image = BlossomRecord.recordArray?.sorted(by: {$0.recordName < $1.recordName})[indexPath.row].isFavorite == true ? UIImage(named: "img_star_filled.png") : UIImage(named: "img_star_empty.png")
                cell!.recordImageView.image = BlossomRecord.recordArray?.sorted(by: {$0.recordName < $1.recordName})[indexPath.row].recordImage
            } else if sortedByLoc == true {
                cell!.nameLabel.text = BlossomRecord.recordArray?.sorted(by: {$0.locName < $1.locName})[indexPath.row].recordName
                cell!.locLabel.text = BlossomRecord.recordArray?.sorted(by: {$0.locName < $1.locName})[indexPath.row].locName
                cell!.starImageView.image = BlossomRecord.recordArray?.sorted(by: {$0.locName < $1.locName})[indexPath.row].isFavorite == true ? UIImage(named: "img_star_filled.png") : UIImage(named: "img_star_empty.png")
                cell!.recordImageView.image = BlossomRecord.recordArray?.sorted(by: {$0.locName < $1.locName})[indexPath.row].recordImage
            } else {
                cell!.nameLabel.text = BlossomRecord.recordArray?[indexPath.row].recordName
                cell!.locLabel.text = BlossomRecord.recordArray?[indexPath.row].locName
                cell!.starImageView.image = BlossomRecord.recordArray?[indexPath.row].isFavorite == true ? UIImage(named: "img_star_filled.png") : UIImage(named: "img_star_empty.png")
                cell!.recordImageView.image = BlossomRecord.recordArray?[indexPath.row].recordImage
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.performSegue(withIdentifier: "RootToRecord", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            if onlyFavorite == true {
                for (index, record) in BlossomRecord.recordArray!.enumerated() where record.recordImageName == favoriteRecordArray?[indexPath.row].recordImageName {
                    BlossomRecord.recordArray?.remove(at: index)
                }
                favoriteRecordArray?.remove(at: indexPath.row)
            } else {
                BlossomRecord.recordArray?.remove(at: indexPath.row)
            }
            BlossomRecord.saveRecordToLocal()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "RootToRecord" {
            let recordVC = segue.destination as! RecordViewController
            recordVC.record = BlossomRecord.recordArray![tableView.indexPathForSelectedRow!.row]
        }
        
        if segue.identifier == "AddNewRecord" {

        }
    }

}

