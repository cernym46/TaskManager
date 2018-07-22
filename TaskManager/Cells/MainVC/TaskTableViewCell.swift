//
//  TaskTableViewCell.swift
//  TaskManager
//
//  Created by Michal Černý on 20/07/2018.
//  Copyright © 2018 Michal Černý. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    // MARK: Variables
    @IBOutlet weak var doneImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var progressImageView: UIButton!
    
    var task : Task? {
        didSet {
            if task?.category != nil {
                colorLabel.text = "•"
                colorLabel.textColor = task?.category?.color as? UIColor
            } else {
                colorLabel.text = ""
            }
                
            titleLabel.text = task?.title
            if task!.deadlineDate != nil {
                let dateString = DateFormatter.localizedString(from: task!.deadlineDate!, dateStyle: .medium, timeStyle: .none)
                
                deadlineLabel.text = "⏳ \(dateString)"
            } else {
                deadlineLabel.text = ""
            }
            
            setBackground(taskComleted: task!.completed)
        }
    }
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setBackground (taskComleted: Bool) {
        backgroundColor = taskComleted ? UIColor.init(red: 235, green: 235, blue: 235) : UIColor.white
        doneImageView.image = taskComleted ? #imageLiteral(resourceName: "done") : #imageLiteral(resourceName: "inProgress")
    }
    
    func setComletion () {
        if let task = task {
            task.completed = !task.completed
            setBackground(taskComleted: task.completed)
        }
    }
    
    // MARK: Actions
    @IBAction func completedBtnClick(_ sender: UIButton) {
        setComletion()
    }
}
