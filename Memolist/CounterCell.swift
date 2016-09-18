//
//  CounterCell.swift
//  Memolist
//
//  Created by 原田大樹 on 2016/09/17.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import UIKit

class CounterCell: UITableViewCell {
    @IBOutlet var label: UILabel!
    @IBOutlet var checkImage: UIImageView!
    @IBOutlet var detailImage: UIImageView!
    @IBOutlet var lineView: UIView!
    
    @IBOutlet var minusImage: UIImageView!
    @IBOutlet var plusImage: UIImageView!
    
    @IBOutlet var countLabel: UILabel!
    
    var item: Item? {
        willSet {
            label.text = newValue?.text
            
            checkImage.tintColor = newValue?.color
            detailImage.tintColor = newValue?.color
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .None
        
        changeImage()
        detailImage.image = detailImage.image?.imageWithRenderingMode(.AlwaysTemplate)
        checkImage.image = checkImage.image?.imageWithRenderingMode(.AlwaysTemplate)
        
        minusImage.image = minusImage.image?.imageWithRenderingMode(.AlwaysTemplate)
        minusImage.tintColor = ColorController.blueGrayColor()
        
        plusImage.image = plusImage.image?.imageWithRenderingMode(.AlwaysTemplate)
        plusImage.tintColor = ColorController.blueGrayColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func checkButton() {
        if let item = self.item {
            if item.check == true {
                item.check = false
            } else {
                item.check = true
            }
            changeImage()
        }
    }
    
    @IBAction func plusButton() {
        if let item = self.item as? Counter {
            item.count += 1
            countLabel.text = "\(item.count)"
        }
    }
    
    @IBAction func minusButton() {
        if let item = self.item as? Counter {
            item.count -= 1
            countLabel.text = "\(item.count)"
        }
    }
    
    private func changeImage() {
        if let item = self.item {
            if item.check == true {
                checkImage.image = CheckImage.check_YES
                lineView.backgroundColor = ColorController.blueGrayColor()
                
            } else {
                checkImage.image = CheckImage.check_NO
                lineView.backgroundColor = UIColor.clearColor()
            }
            checkImage.image = checkImage.image?.imageWithRenderingMode(.AlwaysTemplate)
        }
    }

    
}
