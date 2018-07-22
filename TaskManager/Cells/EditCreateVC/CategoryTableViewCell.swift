//
//  CategoryTableViewCell.swift
//  TaskManager
//
//  Created by Michal Černý on 22/07/2018.
//  Copyright © 2018 Michal Černý. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewCell: UITableViewCell {
    // MARK: Variables
    @IBOutlet weak var collectionView: UICollectionView!
    var selectedIndexPath : IndexPath?
    var task : Task?
    var initilization = true
    weak var delegate: categoryDelegate?
    
    // MARK: CoreData
    var managedObjectContextTasks: NSManagedObjectContext?
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Category> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)] // todo
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContextTasks!, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize =  CGSize(width: 1, height: 1)
        }
        
        collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        
    }
    
    // MARK: Actions
    @IBAction func addCategoryBtnClick(_ sender: UIButton) {
        delegate?.addCategory()
    }
    
    // MARK: Fucntions
    public func selectedCategory () -> Category? {
        if let selectedIndexPath = selectedIndexPath {
            let categoryCell = collectionView.cellForItem(at: selectedIndexPath) as? CategoryCollectionViewCell
            return categoryCell?.category
        }
        return nil
    }
}

extension CategoryTableViewCell: NSFetchedResultsControllerDelegate {
}

extension CategoryTableViewCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        guard let categories = fetchedResultsController.fetchedObjects else { return 0 }
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        
        let category = fetchedResultsController.object(at: indexPath)
        
        cell.category = category
        
        // selected cell
        if (initilization && task?.category == category) {
            cell.isChosen = true
            selectedIndexPath = indexPath
            initilization = false
        } else {
            cell.isChosen = indexPath == selectedIndexPath ? true : false
        }
        
        return cell
    }
}


extension CategoryTableViewCell : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedIndexPath = selectedIndexPath {
            let origin = collectionView.cellForItem(at: selectedIndexPath) as? CategoryCollectionViewCell
            origin?.isChosen = false
        }
        
        let newSelectedCell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell
        newSelectedCell?.isChosen = selectedIndexPath != indexPath
        selectedIndexPath = selectedIndexPath == indexPath ? nil : indexPath
    }
}
