//
//  MemoCell.swift
//  Memolist
//
//  Created by 原田大樹 on 2016/09/10.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import UIKit

class MemoCell: UITableViewCell {
    @IBOutlet var label: UILabel!
    
    var item: Item? {
        willSet {
            label.text = newValue?.text
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
