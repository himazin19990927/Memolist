//
//  SwitchTableViewCell.swift
//  Memolist
//
//  Created by 原田大樹 on 2016/09/25.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import UIKit

protocol SwitchCellDelegate {
    func changedSwitch(on: Bool, tag: Int)
}

class SwitchTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var uiSwitch: UISwitch!
    
    var delegate: SwitchCellDelegate?
    
    var enabled: Bool = true {
        didSet {
            titleLabel.enabled = enabled
            uiSwitch.enabled = enabled
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
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