//
//  CounterCell.swift
//  Memolist
//
//  Created by 原田大樹 on 2016/08/29.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import UIKit

class CounterCell: UITableViewCell {
    @IBOutlet var label: UILabel!
    @IBOutlet var colorView: UIView!
    
    @IBOutlet var plusButton: UIButton!
    @IBOutlet var minusButton: UIButton!
    
    var open: Bool = false {
        willSet {
            label.hidden = !newValue
            colorView.hidden = !newValue
            plusButton.hidden = !newValue
            minusButton.hidden = !newValue
        }
    }

    
    var color: UIColor  {
        set {
            colorView.backgroundColor = newValue
            plusButton.backgroundColor = newValue
            minusButton.backgroundColor = newValue
        }
        
        get {
            return colorView.backgroundColor!
        }
    }
    var counter: Counter? {
        willSet {
            if let counter = newValue {
                label.text = "\(counter.count)"
            } else {
                label.text = "0"
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.accessoryType = .None
        self.selectionStyle = .None
        
        self.plusButton.layer.cornerRadius = 25
        self.minusButton.layer.cornerRadius = 25
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func plus() {
        if let counter = self.counter {
            counter.count += 1
            self.label.text = "\(counter.count)"
        }
    }
    
    @IBAction func minus() {
        if let counter = self.counter {
            counter.count -= 1
            self.label.text = "\(counter.count)"
        }
    }
}
