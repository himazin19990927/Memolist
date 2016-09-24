//
//  TextFieldTableViewCell.swift
//  To Do List
//
//  Created by 原田大樹 on 2016/06/14.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet var textField: UITextField!
    
    var placeholder: String = "" {
        willSet {
            textField.placeholder = newValue
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .None
        
        textField.delegate = self
        textField.clearButtonMode = .Always
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



























