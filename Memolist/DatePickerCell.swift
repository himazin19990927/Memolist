//
//  DatePickerCell.swift
//  To Do List
//
//  Created by 原田大樹 on 2016/08/01.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import UIKit

protocol DatePickerCellDelegate {
    func didChangeDate(date: NSDate, tag: Int)
}

class DatePickerCell: UITableViewCell, UIPickerViewDelegate {
    @IBOutlet var datePicker: UIDatePicker!
    var delegate: DatePickerCellDelegate?
    
    var enabled: Bool = true {
        didSet {
            datePicker.enabled = enabled
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .None
        
        datePicker.addTarget(self, action: #selector(DatePickerCell.onDidChangeDate(_:)), forControlEvents: .ValueChanged)

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func onDidChangeDate(sender: UIDatePicker) {
        if delegate != nil {
            delegate?.didChangeDate(sender.date, tag: tag)
        }
    }
    
}
