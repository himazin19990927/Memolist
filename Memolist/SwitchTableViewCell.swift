//
//  SwitchTableViewCell.swift
//  To Do List
//
//  Created by 原田大樹 on 2016/07/21.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import UIKit

protocol SwitchCellDelegate {
    func changedSwitch(on: Bool, tag: Int)
}

class SwitchTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var inputSwitch: UISwitch!
    
    var delegate: SwitchCellDelegate!
    
    var enabled: Bool = true {
        didSet {
            titleLabel.enabled = enabled
            inputSwitch.enabled = enabled
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.text = "Title"
        self.selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func changedSwitch(sender: UISwitch) {
        delegate?.changedSwitch(sender.on, tag: self.tag)
    }
}
