//
//  TextFieldTableViewCell.swift
//  TaskManager
//
//  Created by Michal Černý on 22/07/2018.
//  Copyright © 2018 Michal Černý. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell, UITextFieldDelegate {

    // MARK: Variables
    @IBOutlet weak var titleTextField: UITextField!
    
    override func awakeFromNib() {
        titleTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}
