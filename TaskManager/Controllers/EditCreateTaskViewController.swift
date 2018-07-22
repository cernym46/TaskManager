//
//  EditCreateTaskViewController.swift
//  TaskManager
//
//  Created by Michal Černý on 21/07/2018.
//  Copyright © 2018 Michal Černý. All rights reserved.
//

import UIKit
import CoreData

protocol categoryDelegate: class {
    func addCategory()
}

class EditCreateTaskViewController: UIViewController, categoryDelegate {
    // MARK: Variables
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteBtn: UIBarButtonItem!
    
    var task: Task?
    
    var showDatePicker = false {
        didSet { tableView.reloadData() }
    }
    
    var titleTextField : UITextField? {
        let titleCell = tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? TextFieldTableViewCell
        return titleCell?.titleTextField
    }
    
    var deadlineSwitch : UISwitch? {
        let deadlineCell = tableView.cellForRow(at: IndexPath(item: 0, section: 1))
        return deadlineCell?.accessoryView as? UISwitch
    }
    
    var deadlineDatePicker : UIDatePicker? {
        let deadlineDatePickerCell = tableView.cellForRow(at: IndexPath(item: 1, section: 1)) as? DatePickerTableViewCell
        return deadlineDatePickerCell?.deadlineDatePicker
    }
    
    // MARK: CoreData
    var managedObjectContextTasks: NSManagedObjectContext?
    
    // MARK: Lifecycle
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showSettings":
            if let destinationViewController = segue.destination as? SettingsViewController {
                // Configure View Controller
                destinationViewController.managedObjectContextTasks = managedObjectContextTasks
            }
        default:
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CategoryTableViewCell")
        tableView.register(UINib(nibName: "TextFieldTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TextFieldTableViewCell")
        tableView.register(UINib(nibName: "DatePickerTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "DatePickerTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationItem.title = task == nil ? "Create task" : "Edit task"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
        
        if let task = task { // edit task
            showDatePicker = task.deadlineDate != nil
            titleTextField?.text = task.title
            
            if let deadlineDate = task.deadlineDate {
                deadlineDatePicker?.date = deadlineDate
            }
        }
    }
    
    // MARK: Actions
    @IBAction func deleteTaskBtnClick(_ sender: UIBarButtonItem) {
        if let task = task {
            task.managedObjectContext?.delete(task)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneBtnClick(_ sender: UIBarButtonItem) {
        let title = titleTextField?.text
        
        let categoryCollectionViewCell = tableView.cellForRow(at: IndexPath(item: 0, section: 2)) as? CategoryTableViewCell
        let selectedCategory = categoryCollectionViewCell?.selectedCategory()
        
        if title?.isEmpty ?? true {
            let alert = UIAlertController(title: "Empty title", message: "You have to fill the title", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil ))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if task == nil { // create mode
            guard let managedObjectContext = managedObjectContextTasks else { return }
            task = Task(context: managedObjectContext)
            task?.completed = false
        }
        
        task?.title = title
        task?.deadlineDate = (deadlineSwitch?.isOn ?? false) ? deadlineDatePicker?.date : nil
        task?.category = selectedCategory
        
            do {
                try managedObjectContextTasks?.save()
            } catch {
                print("Unable to Save Changes")
                print("\(error), \(error.localizedDescription)")
            }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Functions
    func addCategory() {
        self.performSegue(withIdentifier: "showSettings", sender: nil)
    }
}


extension EditCreateTaskViewController:UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if ( indexPath.section == 1 && indexPath.row == 1 ) { return 150 } // date picker
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 2 {
            return "Category"
        }
        return ""
    }
}

extension EditCreateTaskViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:     return 1
        case 1:     return showDatePicker ? 2 : 1
        case 2:     return 1
        default:    return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "id")
        
        switch indexPath.section {
        case 0:
            return tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell", for: indexPath) as! TextFieldTableViewCell
        case 1:
            if indexPath.row == 0 { // deadline switch
                cell.textLabel?.text = "Deadline"
                let sw = UISwitch()
                sw.isOn = showDatePicker
                sw.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
                cell.accessoryView = sw
            } else { // date picker
                return tableView.dequeueReusableCell(withIdentifier: "DatePickerTableViewCell", for: indexPath) as! DatePickerTableViewCell
            }
            break
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
            cell.managedObjectContextTasks = self.managedObjectContextTasks
            cell.task = task
            cell.delegate = self
            cell.collectionView.reloadData()
            return cell
        default:
            break
        }
        
        return cell
    }
    
    @objc func switchChanged(mySwitch: UISwitch) {
        showDatePicker = mySwitch.isOn
    }
}
