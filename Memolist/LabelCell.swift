//
//  LabelCell.swift
//  Memolist
//
//  Created by 原田大樹 on 2016/08/26.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import UIKit

class LabelCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet var label: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var colorView: UIView!
    
    var open: Bool = false {
        willSet {
            label.hidden = !newValue
            dateLabel.hidden = !newValue
            colorView.hidden = !newValue
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
    
    override func awakeFromNib() {
        // Initialization code
        super.awakeFromNib()
        self.selectionStyle = .Gray
        self.accessoryType = .DisclosureIndicator
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
