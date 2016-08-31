//
//  ListTableViewCell.swift
//  To Do List
//
//  Created by 原田大樹 on 2016/05/28.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import UIKit

protocol ListTableViewCellDelegate {
    func editMemo(item: ScheduleItem)
    func reloadCell()
    func alert(viewControllerToPresent: UIViewController)
}
//func presentViewController(viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)

class ListTableViewCell: UITableViewCell {
    var delegate: ListTableViewCellDelegate?
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var colorView: UIView!
    
    private var memo: ScheduleItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        titleLabel.textColor = ColorController.blackColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setItem(item: ScheduleItem) {
        self.memo = item
        
        titleLabel.text = item.title
        colorView.backgroundColor = item.color
    }
    
    @IBAction func editButton() {
        if let delegate = self.delegate {
            delegate.editMemo(memo!)
        }
    }
    
    @IBAction func addItem() {
        
        let alert = UIAlertController(title: "アイテムの追加", message: nil, preferredStyle: .ActionSheet)
        
        let cancel = UIAlertAction(title: "キャンセル", style: .Cancel, handler: nil)
        alert.addAction(cancel)
        
        //check
        let addLabel = UIAlertAction(title: "ラベル", style: .Default, handler: {
            (action: UIAlertAction!) in
            self.memo?.widgets.append(Label())
            self.memo?.open = true
            if let delegate = self.delegate {
                delegate.reloadCell()
            }
        })
        alert.addAction(addLabel)
        
        let addToDo = UIAlertAction(title: "チェックボックス", style: .Default, handler: {
            (action: UIAlertAction!) in
            self.memo?.widgets.append(ToDo())
            self.memo?.open = true
            if let delegate = self.delegate {
                delegate.reloadCell()
            }
        })
        alert.addAction(addToDo)
        
        let addCounter = UIAlertAction(title: "カウンター", style: .Default, handler: {
            (action: UIAlertAction!) in
            self.memo?.widgets.append(Counter())
            self.memo?.open = true
            if let delegate = self.delegate {
                delegate.reloadCell()
            }
            
        })
        alert.addAction(addCounter)
        
        if let delegate = self.delegate {
            delegate.alert(alert)
        }
    }
}













