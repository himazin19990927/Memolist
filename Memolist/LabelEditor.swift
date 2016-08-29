//
//  EditorViewController.swift
//  To Do List
//
//  Created by 原田大樹 on 2016/06/11.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import UIKit

class LabelEditorViewController: UIViewController, UITableViewDataSource , UITableViewDelegate,TextFieldCellDelegate, SwitchCellDelegate, DatePickerCellDelegate {
    @IBOutlet var tableView: UITableView!
    
    var textFieldCellArray: [UITableViewCell] = []
    var dateCellArray: [UITableViewCell] = []
    
    var checkBarButton: UIBarButtonItem!
    
    var switchValue: Bool = false
    var date: NSDate!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableViewの設定
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = ColorController.lightGrayColor()
        //NavigationBarの設定
        self.title = "ラベルの設定"
        self.navigationController?.navigationBar.barTintColor = ColorController.whiteColor()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Default
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: ColorController.blackColor()]
        
        //NavigationBarのボタンの設定
        let backButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
        
        
        //NavigationBarのボタンの設定
        checkBarButton = UIBarButtonItem(image: UIImage(named: "Check"), style: .Done, target: self, action: #selector(LabelEditorViewController.checkButtonClicked(_:)))
        
        checkBarButton.enabled = true
        
        
        self.navigationItem.rightBarButtonItem = checkBarButton
        
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
        
        //cellの設定
        self.tableView.registerNib(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFieldTableViewCell")
        self.tableView.registerNib(UINib(nibName: "SwitchTableViewCell", bundle: nil), forCellReuseIdentifier: "SwitchTableViewCell")
        self.tableView.registerNib(UINib(nibName: "DatePickerCell", bundle: nil), forCellReuseIdentifier: "DatePickerCell")
        
        initCell()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func didMoveToParentViewController(parent: UIViewController?) {
        super.willMoveToParentViewController(parent)
    }
    
    //viewが表示される直前に呼ばれる
    override func viewWillAppear(animated: Bool) {
        //initCell()
        //tableView.reloadData()
        
    }
    
    //セクションの数を設定
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    //セルが選択された時に呼ばれる
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
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
    
    //Cellの数を設定
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return textFieldCellArray.count
        case 1:
            return dateCellArray.count
        default:
            break
        }
        return 0
    }
    
    //tableViewにCellを登録
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return textFieldCellArray[indexPath.row]
        case 1:
            return dateCellArray[indexPath.row]
        default:
            break
        }
        return UITableViewCell()
    }
    
    //cellの高さを設定
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 1 {
            let datePickerCell = dateCellArray[1] as! DatePickerCell
            if switchValue {
                datePickerCell.datePicker.hidden = false
                return 216
            } else {
                datePickerCell.datePicker.hidden = true
                return 0
            }
        }
        return 44
    }
    
    //テキストフィールドの入力が終わった時に呼ばれるデリゲートメソッド
    func upDate(canEnable: Bool) {
        //checkBarButton.enabled = canEnable
    }
    
    //右のボタンが押された時に呼ばれる
    func checkButtonClicked(sender: AnyObject) {
        let textFieldCell = textFieldCellArray[0] as! TextFieldTableViewCell
        
        if let text = textFieldCell.inputTextField.text {
            let label = ItemController.instance.item as! Label
            label.text = text
            
            if switchValue {
                let datePickerCell = dateCellArray[1] as! DatePickerCell
                label.date = datePickerCell.datePicker.date
            } else {
                label.date = nil
            }
            
            ItemController.instance.item = nil
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    
    //Cellを初期化
    func initCell() {
        
        textFieldCellArray.removeAll()
        
        //section == 0 (textFieldCellArray)
        //row == 0
        //ラベルを設定するセル
        let textFieldCell = tableView.dequeueReusableCellWithIdentifier("TextFieldTableViewCell") as! TextFieldTableViewCell
        textFieldCell.placeholder = "ラベル"
        let label = ItemController.instance.item as! Label
        textFieldCell.inputTextField.text = label.text
        textFieldCell.delegate = self
        textFieldCellArray.append(textFieldCell)
        
        //section == 1
        //row == 0
        let switchCell = tableView.dequeueReusableCellWithIdentifier("SwitchTableViewCell") as! SwitchTableViewCell
        switchCell.titleLabel.text = "日付を表示"
        switchCell.delegate = self
        if label.date == nil {
            self.switchValue = false
            switchCell.inputSwitch.on = false
        } else {
            self.switchValue = true
            switchCell.inputSwitch.on = true
        }
        
        switchCell.tag = 0
        dateCellArray.append(switchCell)
        
        //row == 1
        let datePickerCell = tableView.dequeueReusableCellWithIdentifier("DatePickerCell") as! DatePickerCell
        datePickerCell.delegate = self
        datePickerCell.enabled = false
        dateCellArray.append(datePickerCell)
        
    }
    
    //switchの値が変わった時呼ばれる
    func changedSwitch(on: Bool, tag: Int) {
        tableView.beginUpdates()
        self.switchValue = on
        let datePickerCell = dateCellArray[1] as! DatePickerCell
        datePickerCell.enabled = on
        tableView.endUpdates()
    }
    
    
    //datePickerの値が変わった時呼ばれる
    func didChangeDate(date: NSDate, tag: Int) {
        
    }
}

























