//
//  ScheduleCell.swift
//  Memolist
//
//  Created by 原田大樹 on 2016/09/25.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import UIKit

class ScheduleCell: UITableViewCell {
    @IBOutlet var label: UILabel!
    @IBOutlet var checkImage: UIImageView!
    @IBOutlet var detailImage: UIImageView!
    @IBOutlet var lineView: UIView!
    
    @IBOutlet var openView: UIView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var countdownLabel: UILabel!
    
    var delegate: ItemEditorDelegate?
    var openCellDelegate: OpenCellDelegate?
    
    var item: Item? {
        didSet {
            if let item = item as? Schedule {
                label.text = item.text
                
                checkImage.tintColor = item.color
                detailImage.tintColor = item.color
                
                openView.hidden = !item.open
                
                if let date = item.date {
                    let formatter = NSDateFormatter()
                    formatter.dateFormat = "yyyy/MM/dd"
                    dateLabel.text = formatter.stringFromDate(date)
                    
                    let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
                    let now = NSDate()
                    let nowdate = calendar.dateBySettingHour(0, minute: 0, second: 0, ofDate: now, options: NSCalendarOptions())!
                    
                    let span = date.timeIntervalSinceDate(nowdate)
                    let daySpan = Int(span / 60 / 60 / 24)
                    if daySpan == 0 {
                        countdownLabel.text = "今日"
                    } else if daySpan == 1 {
                        countdownLabel.text = "明日"
                    } else if daySpan == 2 {
                        countdownLabel.text = "明後日"
                    } else if daySpan == -1 {
                        countdownLabel.text = "昨日"
                    } else if daySpan == -2 {
                        countdownLabel.text = "一昨日"
                    } else if daySpan > 1 {
                        countdownLabel.text = "\(daySpan)日後"
                    } else if daySpan < 0 {
                        countdownLabel.text = "\(-daySpan)日前"
                    }

                } else {
                    dateLabel.text = "日付指定無し"
                    countdownLabel.text = ""
                }
            }
            changeImage()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .None
        
        label.textColor = ColorController.blackColor()
        dateLabel.textColor = ColorController.blackColor()
        countdownLabel.textColor = ColorController.blackColor()
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
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
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