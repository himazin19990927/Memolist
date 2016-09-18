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
    @IBOutlet var checkImage: UIImageView!
    @IBOutlet var detailImage: UIImageView!
    @IBOutlet var lineView: UIView!
    
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
        self.selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        changeImage()
        
        detailImage.image = detailImage.image?.imageWithRenderingMode(.AlwaysTemplate)
        checkImage.image = checkImage.image?.imageWithRenderingMode(.AlwaysTemplate)
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




























