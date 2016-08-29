//
//  LabelTableViewCell.swift
//  To Do List
//
//  Created by 原田大樹 on 2016/07/22.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import UIKit

class LabelTableViewCell: UITableViewCell {
    @IBOutlet var leftLabel: UILabel!
    @IBOutlet var rightLabel: UILabel!
    
    var enabled: Bool = true {
        didSet {
            leftLabel.enabled = enabled
            rightLabel.enabled = enabled
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        leftLabel.text = ""
        rightLabel.text = ""
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
