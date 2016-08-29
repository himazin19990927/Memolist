//
//  ListTableViewCell.swift
//  To Do List
//
//  Created by 原田大樹 on 2016/05/28.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import UIKit

protocol ListTableViewCellDelegate {
    func editMemo(item: ScheduleItem)
}

class ListTableViewCell: UITableViewCell {
    var delegate: ListTableViewCellDelegate?
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var colorView: UIView!
    
    private var memo: ScheduleItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        titleLabel.textColor = ColorController.blackColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setItem(item: ScheduleItem) {
        self.memo = item
        
        titleLabel.text = item.title
        colorView.backgroundColor = item.color
    }
    
    @IBAction func editButton() {
        if let delegate = self.delegate {
            delegate.editMemo(memo!)
        }
    }
}













