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
    
    @IBOutlet var openView: UIView!
    @IBOutlet var memoTextView: UITextView!
    
    var delegate: ItemEditorDelegate?
    var openCellDelegate: OpenCellDelegate?
    
    var item: Item? {
        didSet {
            if let item = item as? Memo{
                label.text = item.text
                
                memoTextView.text = item.memo
                
                checkImage.tintColor = item.color
                detailImage.tintColor = item.color
                
                openView.hidden = !item.open
            }
            changeImage()
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
    
    @IBAction func editButton() {
        if let item = self.item {
            delegate?.editItem(item)
        }
    }
    
    @IBAction func openButton() {
        if let item = self.item, let openCellDelegate = self.openCellDelegate {
            item.open = !item.open
            
            if item.open {
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_main_queue()) {
                    self.openView.hidden = false
                }
            } else {
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_main_queue()) {
                    self.openView.hidden = true
                }
            }
            openCellDelegate.changeOpenCell()
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




























