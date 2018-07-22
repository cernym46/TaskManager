//
//  CategoryCollectionViewCell.swift
//  TaskManager
//
//  Created by Michal Černý on 22/07/2018.
//  Copyright © 2018 Michal Černý. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    // MARK: Variables
    var isChosen = false {
        didSet {
            bcgView.layer.borderWidth = isChosen ? 2 : 0
            bcgView.layer.borderColor = UIColor.blue.cgColor
        }
    }
    
    var category : Category? {
        didSet {
            nameLabel.text = category?.name
            nameLabel.textColor = UIColor.white
            
            bcgView.backgroundColor = (category?.color as? UIColor) ?? UIColor.blue
            bcgView.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet weak var bcgView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
}
