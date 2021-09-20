//
//  TestYourselfViewController.swift
//  WordPic Match
//
//  Created by user202300 on 9/18/21.
//  Copyright © 2021 user162638. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class TestYourselfViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var wordList: UITableView!
    @IBOutlet weak var testImage: UIImageView!
    
    private var pairs = [WordImagePair]()
    
    var displayImagePath = ""
    
    var randomIndex = -1
    
    var filesURL: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pairs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = pairs[indexPath.row].text
        //let myFont: UIFont = [UIFont fontWithName: "@Arial", size: 20]
        cell.textLabel?.font = UIFont(name: "Arial", size: 40)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Check if the match is correct or not
        let cell = wordList.cellForRow(at: indexPath)
        wordList.deselectRow(at: indexPath, animated: true)
        if cell?.textLabel!.text == pairs[randomIndex].text {
            let alert = UIAlertController(title: "Correct!", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated:true)
            
            randomIndex = Int.random(in: 0..<pairs.count)
            print(randomIndex)
            
            displayImagePath = pairs[randomIndex].imagePath
            print(displayImagePath)
            
            let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
            
            let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
            
            let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
            
            if let dirPath = paths.first {
                let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(displayImagePath)
                testImage.image = UIImage(contentsOfFile: imageURL.path)
            }
        }
        else {
            let alert = UIAlertController(title: "Incorrect!", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
            self.present(alert, animated:true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Here 1")
        
        wordList.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        wordList.delegate = self
        wordList.dataSource = self
        
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: {migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                    //do nothing
                }
            })
        Realm.Configuration.defaultConfiguration = config
        
        print("Here 2")
        
        let realm = try! Realm()
        
        pairs = realm.objects(WordImagePair.self).map({ $0 })
        
        print(pairs)
        
        if (!pairs.isEmpty) {
            
            randomIndex = Int.random(in: 0..<pairs.count)
            print(randomIndex)
            
            displayImagePath = pairs[randomIndex].imagePath
            print(displayImagePath)
            
            let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
            
            let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
            
            let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
            
            if let dirPath = paths.first {
                let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(displayImagePath)
                testImage.image = UIImage(contentsOfFile: imageURL.path)
            }
            
            /*let imageURL = URL.init(fileURLWithPath: displayImagePath)
            do {
                let imageData: NSData = try NSData(contentsOf: imageURL)
                testImage.image = UIImage(data: imageData as Data)
            }
            catch {
                let alert = UIAlertController(title: "Error", message: "Error loading image", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true)
            }*/
            
            
            //let imageData = NSData(contentsOfFile: displayImagePath)
           /* do {
                testImage.image = try UIImage(data: imageData)
            }
            catch {
                let alert = UIAlertController(title: "Error", message: "Error loading image", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true)
            }*/
            //let imageURL = filesURL.appendingPathComponent(displayImagePath)
            /*let imageURL = URL(string: displayImagePath)
            do {
                let imageData = try Data(contentsOf: imageURL!)
                testImage.image = UIImage(data: imageData)
            }
            catch {
                let alert = UIAlertController(title: "Error", message: "Error loading image", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true)
            }*/
        }
        else {
            let alert = UIAlertController(title: "Error", message: "Add image-word pairs first", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}
