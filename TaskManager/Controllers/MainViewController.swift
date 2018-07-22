//
//  ViewController.swift
//  TaskManager
//
//  Created by Michal Černý on 20/07/2018.
//  Copyright © 2018 Michal Černý. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    // MARK: Variables
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: CoreData
    private let persistentContainer = NSPersistentContainer(name: "TaskManager")
    var managedObjectContextTasks: NSManagedObjectContext?
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Task> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)] // todo
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    // MARK: Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showNewTask":
            if let destinationViewController = segue.destination as? EditCreateTaskViewController {
                // Configure View Controller
                destinationViewController.managedObjectContextTasks = managedObjectContextTasks
            }
        case "showEditTask":
            if let destinationViewController = segue.destination as? EditCreateTaskViewController {
                // Configure View Controller
                destinationViewController.managedObjectContextTasks = managedObjectContextTasks
                destinationViewController.task = sender as? Task
            }
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
        
        tableView.tableFooterView = UIView() // hiding unnecessary separators
        
        tableView.register(UINib(nibName: "TaskTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TaskTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        
        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
                
            } else {
                do {
                    try self.fetchedResultsController.performFetch()
                } catch {
                    let fetchError = error as NSError
                    print("Unable to Perform Fetch Request")
                    print("\(fetchError), \(fetchError.localizedDescription)")
                }
                
                self.updateView()
            }
        }
        
        managedObjectContextTasks = persistentContainer.viewContext
    }
    
    // MARK: Functions
    private func updateView() {
        let tasks = fetchedResultsController.fetchedObjects
        let hasTasks = (tasks?.count ?? 0) > 0
        
        messageLabel.isHidden = hasTasks
    }
}

extension ViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        updateView()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        default:
            break
        }
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tasks = fetchedResultsController.fetchedObjects else { return 0 }
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell") as! TaskTableViewCell
        let task = fetchedResultsController.object(at: indexPath)
        cell.task = task
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = fetchedResultsController.object(at: indexPath)
        performSegue(withIdentifier: "showEditTask", sender: task)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Fetch Task
            let task = fetchedResultsController.object(at: indexPath)
            
            // Delete Task
            task.managedObjectContext?.delete(task)
        }
    }
}
