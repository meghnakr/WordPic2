//
//  AddPhotosViewController.swift
//  WordPic Match
//
//  Created by user202300 on 9/18/21.
//  Copyright © 2021 user162638. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import RealmSwift

class WordImagePair: Object {
    @objc dynamic var text: String = ""
    @objc dynamic var imagePath: String = ""
}

class AddPhotosViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageUploaded: UIImageView!
    
    @IBOutlet weak var words: UITextField!
    
    var imageUploadedPath = ""
    
    //let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageUploaded.isUserInteractionEnabled = true
        
        /*let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: {migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                    //do nothing
                }
            })
        Realm.Configuration.defaultConfiguration = config*/
        
    }
    
    @IBAction func onTapCameraPhotos(_ sender: Any) {
        print("Clicked photo")
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //imageUploadedPath = info[UIImagePickerController.InfoKey.referenceURL] as! String
        if let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage? {
            let imageURL = info[UIImagePickerController.InfoKey.referenceURL] as! URL
            print("Here is the the image URL: " + (imageURL.absoluteString ?? "Error"))
            //imageUploadedPath = imageURL.absoluteString ?? "Error"
            var imageName = imageURL.lastPathComponent
            imageName = String(Int.random(in: 0..<1000000)) + imageName
            print(imageName)
            //let documentDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!) as String
            guard let documentDirectory =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
            let fileURL = documentDirectory.appendingPathComponent(imageName)
            guard let data = image.pngData() else {return}
            
            imageUploaded.image = image
            //let data = image.pngData()
            
            if FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    try FileManager.default.removeItem(atPath: fileURL.path)
                    print("Removed old image")
                }
                catch let removeError {
                    print("Couldn't remove file at path", removeError)
                }
            }
            
            do {
                try data.write(to: fileURL)
            }
            catch let error {
                print("error saving file with error", error)
            }
            
            //try! data!.write(to: URL(fileURLWithPath: localPath))
            
            imageUploadedPath = imageName 
                        
            dismiss(animated: true, completion: nil)
        }
    }
    
    //press Done button
    @IBAction func upload(_ sender: Any) {
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: {migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                    //do nothing
                }
            })
        Realm.Configuration.defaultConfiguration = config
        
        let realm = try! Realm()
        
        if words.hasText {
            
            realm.beginWrite()
            
            let newPair = WordImagePair()
            newPair.text = words!.text as! String
            newPair.imagePath = imageUploadedPath
                
            realm.add(newPair)
            
            try! realm.commitWrite()
            
            let alert = UIAlertController(title: "Done", message: "Image and Text saved", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            
            words.text = ""
        }
    }
    
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    
}
