//
//  ViewController.swift
//  TipMaster
//
//  Created by user162638 on 1/15/20.
//  Copyright © 2020 user162638. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var tipControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func clearDatabase(_ sender: Any) {
        let alert = UIAlertController(title: "Clear database?", message: "Are you sure you want to delete all images and words?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
            let config = Realm.Configuration(
                schemaVersion: 1,
                migrationBlock: {migration, oldSchemaVersion in
                    if (oldSchemaVersion < 1) {
                        //do nothing
                    }
                })
            Realm.Configuration.defaultConfiguration = config
            let realm = try! Realm()
            realm.beginWrite()
            realm.deleteAll()
            try! realm.commitWrite()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func onTap(_ sender: Any) {
        print("Hello")
        
        view.endEditing(true)
    }
    
    @IBAction func calculateTip(_ sender: Any) {
        //Get the bill amount
        let bill = Double(billField.text!) ?? 0
        
        //Calculate the tip and total
        let tipPercentages = [0.15, 0.18, 0.2]
        let tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
        let total = bill + tip
        
        //Update the tip and total labels
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
    }
    
}

