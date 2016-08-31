//
//  ToDoCell.swift
//  Memolist
//
//  Created by 原田大樹 on 2016/08/30.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import UIKit

class ToDoCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet var label: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var colorView: UIView!
    @IBOutlet var checkButtonImage: UIImageView!
    
    var toDo: ToDo?
    
    var open: Bool = false {
        willSet {
            label.hidden = !newValue
            dateLabel.hidden = !newValue
            colorView.hidden = !newValue
            checkButtonImage.hidden = !newValue
        }
    }
    
    var color: UIColor  {
        set {
            colorView.backgroundColor = newValue
        }
        
        get {
            return colorView.backgroundColor!
        }
    }
    
    var check: Bool {
        set {
            if newValue {
                checkButtonImage.backgroundColor = self.color
            } else {
                checkButtonImage.backgroundColor = ColorController.lightGrayColor()
            }
        }
        
        get {
            return false
        }
    }
    
    override func awakeFromNib() {
        // Initialization code
        super.awakeFromNib()
        self.selectionStyle = .Gray
        self.accessoryType = .DisclosureIndicator
        
        label.textColor = ColorController.blackColor()
        dateLabel.textColor = ColorController.blackColor()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    @IBAction func checkButtonClicked() {
        if let toDo = self.toDo {
            if toDo.check! {
                toDo.check = false
                checkButtonImage.backgroundColor = ColorController.lightGrayColor()
            } else {
                toDo.check = true
                checkButtonImage.backgroundColor = self.color
            }
        }
    }
}




















