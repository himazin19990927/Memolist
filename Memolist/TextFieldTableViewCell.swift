//
//  TextFieldTableViewCell.swift
//  To Do List
//
//  Created by 原田大樹 on 2016/06/14.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import UIKit

protocol TextFieldCellDelegate {
    func upDate(canEnable: Bool)
}

class TextFieldTableViewCell: UITableViewCell, UITextFieldDelegate {
    var delegate: TextFieldCellDelegate!
    var maxLength: Int = 12
    @IBOutlet var inputTextField: UITextField!
    
    var placeholder: String = "" {
        willSet {
            inputTextField.placeholder = newValue
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .None
        
        inputTextField.delegate = self
        inputTextField.clearButtonMode = .Always
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        inputTextField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        delegate?.upDate(false)
        inputTextField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let textFieldCount = textField.text!.characters.count
        let stringCount = string.characters.count
        
        //textFieldの文字が1文字の時に消去されればボタンを押せなくする
        if textFieldCount == 1 && stringCount == 0 {
            delegate?.upDate(false)
            return true
        }
        
        if textFieldCount + stringCount <= maxLength {
            delegate?.upDate(true)
            return true
        }
        delegate?.upDate(true)
        return false
    }
}



























