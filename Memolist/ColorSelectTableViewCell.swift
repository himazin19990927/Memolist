//
//  ColorSelectTableViewCell.swift
//  To Do List
//
//  Created by 原田大樹 on 2016/08/24.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import UIKit

class ColorSelectTableViewCell: UITableViewCell {
    var color: UIColor = UIColor.blueColor() {
        willSet {
            self.backgroundColor = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .Gray
        self.accessoryType = .DisclosureIndicator
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
