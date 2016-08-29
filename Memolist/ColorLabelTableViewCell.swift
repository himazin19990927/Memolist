//
//  ColorLabelTableViewCell.swift
//  To Do List
//
//  Created by 原田大樹 on 2016/08/24.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import UIKit

class ColorLabelTableViewCell: UITableViewCell {
    @IBOutlet var colorView: UIView!
    @IBOutlet var label: UILabel!
    
    var color: UIColor = UIColor.blackColor() {
        willSet {
            colorView.backgroundColor = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        colorView.layer.cornerRadius = 10
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
