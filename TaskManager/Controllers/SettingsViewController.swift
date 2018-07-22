//
//  SettingsViewController.swift
//  TaskManager
//
//  Created by Michal Černý on 21/07/2018.
//  Copyright © 2018 Michal Černý. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController {
    // MARK: Variables
    var chosenColor : UIColor?
    var colorBtns : [UIButton]!
    
    @IBOutlet weak var categoryNameTextField: UITextField!
    @IBOutlet weak var lightGreenBtn: UIButton!
    @IBOutlet weak var greenBtn: UIButton!
    @IBOutlet weak var orangeBtn: UIButton!
    @IBOutlet weak var yellowBtn: UIButton!
    @IBOutlet weak var redBtn: UIButton!
    @IBOutlet weak var pinkBtn: UIButton!
    @IBOutlet weak var notificationsSwitch: UISwitch!
    
    // MARK: CoreData
    var managedObjectContextTasks: NSManagedObjectContext?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryNameTextField.delegate = self
        notificationsSwitch.isOn = UIApplication.shared.isRegisteredForRemoteNotifications
        colorBtns = [lightGreenBtn, greenBtn, orangeBtn, yellowBtn, redBtn, pinkBtn]
        
        let cornerRadius = colorBtns[0].frame.height/2
        for i in colorBtns.indices {
            colorBtns[i].layer.cornerRadius = cornerRadius
            
            if ColorsPalette.allColors.indices.contains(i){
                colorBtns[i].backgroundColor = ColorsPalette.allColors[i]
            } else {
                print("error number of colors")
            }
        }
        
        chosenColor = colorBtns[0].backgroundColor
        colorBtns[0].layer.borderWidth = 2
        colorBtns[0].layer.borderColor = UIColor.blue.cgColor
    }
    
    // MARK: Actions
    @IBAction func addCategoryBtnClick(_ sender: UIButton) {
        guard let managedObjectContext = managedObjectContextTasks else { return }
        let category : Category = Category(context: managedObjectContext)
        
        category.color = chosenColor
        category.name = categoryNameTextField.text

        let alert = UIAlertController(title: "Successfully created", message: "New category was successfully created", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil ))
        self.present(alert, animated: true, completion: nil)
        
        do {
            try managedObjectContextTasks?.save()
        } catch {
            print("Unable to Save Changes")
            print("\(error), \(error.localizedDescription)")
        }
    }
    
    @IBAction func notificationsSwitchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            UIApplication.shared.registerForRemoteNotifications()
        } else {
            UIApplication.shared.unregisterForRemoteNotifications()
        }
    }
    
    @IBAction func colorBtnClick(_ sender: UIButton) {
        for btn in colorBtns {
            btn.layer.borderWidth = 0
        }
        
        chosenColor = sender.backgroundColor
        
        sender.layer.borderWidth = 2
        sender.layer.borderColor = UIColor.blue.cgColor
    }
}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}

extension SettingsViewController: NSFetchedResultsControllerDelegate{
}
