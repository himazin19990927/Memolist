//
//  ScheduleEditorViewController.swift
//  Memolist
//
//  Created by 原田大樹 on 2016/09/25.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import Foundation
import UIKit

class ScheduleEditorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate {
    @IBOutlet var tableView: UITableView!
    
    var titleCells: [UITableViewCell] = []
    var colorSelectorCells: [UITableViewCell] = []
    var dateSelectorCells: [UITableViewCell] = []
    
    var closeBarButton: UIBarButtonItem!
    var addBarButton: UIBarButtonItem!
    
    var dateSelectorOpen: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableviewの設定
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = ColorController.lightGrayColor()
        tableView.separatorColor = ColorController.blueGrayColor()
        
        //NavigationBarの設定
        self.title = "予定の編集"
        self.navigationController?.navigationBar.barTintColor = ColorController.whiteColor()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Default
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: ColorController.blackColor()]
        
        //NavigationBarのボタンの設定
        let backButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
        
        closeBarButton = UIBarButtonItem(image: UIImage(named: "Close"), style: .Done, target: self, action: #selector(ItemCreatorViewController.closeButtonClicked(_:)))
        navigationItem.leftBarButtonItem = closeBarButton
        
        addBarButton = UIBarButtonItem(image: UIImage(named: "Check"), style: .Done, target: self, action: #selector(ItemCreatorViewController.addButtonClicked(_:)))
        navigationItem.rightBarButtonItem = addBarButton
        
        //NavigationBarに線を表示する
        let hairlineView = UIView()
        hairlineView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(hairlineView)
        let hairlineView_constraint_H:Array = NSLayoutConstraint.constraintsWithVisualFormat("H:|[hairlineView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["hairlineView":hairlineView])
        let hairlineView_constraint_V:Array = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[hairlineView(0.5)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["hairlineView":hairlineView])
        self.view.addConstraints(hairlineView_constraint_H)
        self.view.addConstraints(hairlineView_constraint_V)
        hairlineView.backgroundColor = ColorController.blueGrayColor()
        
        //Cellが表示されてない時は区切り線を消す
        let clearView:UIView = UIView(frame: CGRectZero)
        clearView.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = clearView
        tableView.tableHeaderView = clearView
        
        //セルの初期化
        self.tableView.registerNib(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFieldTableViewCell")
        self.tableView.registerNib(UINib(nibName: "ColorLabelTableViewCell", bundle: nil), forCellReuseIdentifier: "ColorLabelTableViewCell")
        self.tableView.registerNib(UINib(nibName: "LabelTableViewCell", bundle: nil), forCellReuseIdentifier: "LabelTableViewCell")
        self.tableView.registerNib(UINib(nibName: "TextViewTableViewCell", bundle: nil), forCellReuseIdentifier: "TextViewTableViewCell")
        self.tableView.registerNib(UINib(nibName: "SwitchTableViewCell", bundle: nil), forCellReuseIdentifier: "SwitchTableViewCell")
        self.tableView.registerNib(UINib(nibName: "DatePickerCell", bundle: nil), forCellReuseIdentifier: "DatePickerCell")
        
        //セルの設定
        initCell()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        //viewが表示される前にcellの色を替える
        let colorLabelCell = colorSelectorCells[0] as! ColorLabelTableViewCell
        if let color = ScheduleController.instance.scheduleBuf?.color {
            colorLabelCell.color = color
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        //viewが表示されるときキーボードを開く
        let titleCell = titleCells[0] as! TextFieldTableViewCell
        titleCell.textField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        //viewが閉じられるときキーボードを閉じる
        let titleCell = titleCells[0] as! TextFieldTableViewCell
        titleCell.textField.endEditing(true)
    }
    
    //セクションの数を設定
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    //セルが選択された時に呼ばれる
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.section {
        case 0:
            //titleCells
            break
        case 1:
            //colorSelectorCells
            performSegueWithIdentifier("MoveToScheduleColorSelector", sender: nil)
            break
        case 2:
            //dateSelectorCells
            break
        default:
            break
        }
    }
    
    //セルの数を設定
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            //titleCells
            return titleCells.count
        case 1:
            //colorSelectorCells
            return colorSelectorCells.count
        case 2:
            //dateSelectorCells
            return dateSelectorCells.count
        default:
            break
        }
        
        return 0
    }
    
    //セルを設定
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            //titleCells
            return titleCells[indexPath.row]
        case 1:
            //colorSelectorCells
            return colorSelectorCells[indexPath.row]
        case 2:
            //dateSelectorCells
            return dateSelectorCells[indexPath.row]
        default:
            break
        }
        return UITableViewCell()
    }
    
    //headerのUIViewを設定
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view
    }
    
    //headerの高さを設定
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    //footerのUIViewを設定
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view
    }
    
    //footerの高さを設定
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            return 300
        }
        
        return 0
    }
    
    //cellの高さを設定
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 2 {
            if dateSelectorOpen {
                switch indexPath.row {
                case 0:
                    break
                case 1:
                    let datePickerCell = dateSelectorCells[1] as! DatePickerCell
                    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.2 * Double(NSEC_PER_SEC)))
                    dispatch_after(delayTime, dispatch_get_main_queue()) {
                        datePickerCell.datePicker.hidden = false
                    }
                    return 216
                default:
                    break
                }
            } else {
                switch indexPath.row {
                case 0:
                    break
                case 1:
                    let datePickerCell = dateSelectorCells[1] as! DatePickerCell
                    datePickerCell.datePicker.hidden = true
                    return 0
                default:
                    break
                }
            }
        }
        return 50
    }
    
    
    func initCell() {
        titleCells.removeAll()
        colorSelectorCells.removeAll()
        
        //section == 0 (titleCells)
        //row == 0
        //タイトルを設定するセル
        let titleCell = tableView.dequeueReusableCellWithIdentifier("TextFieldTableViewCell") as! TextFieldTableViewCell
        titleCell.textField.text = ScheduleController.instance.scheduleBuf!.text
        titleCell.placeholder = "タイトル"
        titleCells.append(titleCell)
        
        //section == 1 (colorSelectorCells)
        //row == 0
        //色を設定するセル
        let colorLabelCell = tableView.dequeueReusableCellWithIdentifier("ColorLabelTableViewCell") as! ColorLabelTableViewCell
        colorLabelCell.label.text = "色"
        
        colorSelectorCells.append(colorLabelCell)
        
        //section == 2 (dateSelectorCells)
        //row == 0
        let switchCell = tableView.dequeueReusableCellWithIdentifier("SwitchTableViewCell") as! SwitchTableViewCell
        switchCell.titleLabel.text = "日付を設定"
        switchCell.delegate = self
        
        dateSelectorCells.append(switchCell)
        
        //row == 1
        let datePickerCell = tableView.dequeueReusableCellWithIdentifier("DatePickerCell") as! DatePickerCell
        datePickerCell.datePicker.datePickerMode = .Date
        dateSelectorCells.append(datePickerCell)
        
        if let date = ScheduleController.instance.scheduleBuf?.date {
            dateSelectorOpen = true
            datePickerCell.datePicker.date = date
        } else {
            dateSelectorOpen = false
            datePickerCell.datePicker.date = NSDate()
            switchCell.uiSwitch.on = false
        }
        
    }
    
    func closeButtonClicked(sender: AnyObject) {
        MemoController.instance.memo = nil
        MemoController.instance.memoBuf = nil
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addButtonClicked(sender: AnyObject) {
        let schedule = ScheduleController.instance.schedule!
        
        let titleCell = titleCells[0] as! TextFieldTableViewCell
        schedule.text = titleCell.textField.text!
        
        let scheduleBuf = ScheduleController.instance.scheduleBuf!
        schedule.color = scheduleBuf.color
        
        if dateSelectorOpen {
            let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
            
            let datePickerCell = dateSelectorCells[1] as! DatePickerCell
            let datePickerDate = datePickerCell.datePicker.date
            let date = calendar.dateBySettingHour(0, minute: 0, second: 0, ofDate: datePickerDate, options: NSCalendarOptions())
            schedule.date = date
        } else {
            schedule.date = nil
        }
        
        ScheduleController.instance.schedule = nil
        ScheduleController.instance.scheduleBuf = nil
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func changedSwitch(on: Bool, tag: Int) {
        tableView.beginUpdates()
        dateSelectorOpen = on
        tableView.endUpdates()
    }
}

















