//
//  RecordViewController.swift
//  CSCI_3310_Asg2
//
//  Created by me on 26/10/2017.
//  Copyright © 2017 myself. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var recordNavigationItem: UINavigationItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var locTextField: UITextField!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var imagePicker = UIImagePickerController()
    
    var record = BlossomRecord()
    
    @IBAction func cancelButtonTriggered(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTriggered(_ sender: UIBarButtonItem) {
        record.recordName = nameTextField.text ?? ""
        record.locName = locTextField.text ?? ""
        
        let DATE_FORMATTER = DateFormatter()
        DATE_FORMATTER.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        DATE_FORMATTER.locale = Locale.current
        record.recordImageName = DATE_FORMATTER.string(from: Foundation.Date())
        
        
        #if DEBUG
            print("recordName : '\(record.recordName)'")
            print("locName : '\(record.locName)'")
            print("isFavorite : '\(record.isFavorite)'")
            print("recordImageName : '\(record.recordImageName)'")
            print("recordImage : '\(record.recordImage)'")
            #endif
        
        BlossomRecord.recordArray?.append(record)
        BlossomRecord.saveRecordToLocal()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func favoriteButtonTriggered(_ sender: UIButton) {
        
        if favoriteButton.currentImage == UIImage(named: "img_star_filled.png") {
            record.isFavorite = false
            favoriteButton.setImage(UIImage(named: "img_star_add.png"), for: .normal)
        } else {
            record.isFavorite = true
            favoriteButton.setImage(UIImage(named: "img_star_filled.png"), for: .normal)
        }
    }
    
    @IBAction func recordImageButtonTriggered(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        locTextField.delegate = self
        recordNavigationItem.title = record.recordName ?? "New Blossom"
        
        nameTextField.text = record.recordName
        locTextField.text = record.locName

        favoriteButton.setImage(record.isFavorite == true ? UIImage(named: "img_star_filled.png") : UIImage(named: "img_star_add.png"), for: .normal)
        imageButton.setImage(record.recordImage ?? UIImage(named: "img_no_photo.png"), for: .normal)
        
        saveButton.isEnabled = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
        //  MARK :- UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nameTextField {
            saveButton.isEnabled = true
        }
    }
    
    
        //  MARK :- UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        record.recordImage = image
        imageButton.setImage(image, for: .normal)
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
}
