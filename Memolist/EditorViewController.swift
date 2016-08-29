//
//  EditorViewController.swift
//  To Do List
//
//  Created by 原田大樹 on 2016/06/11.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController, UITableViewDataSource , UITableViewDelegate,TextFieldCellDelegate {
    @IBOutlet var tableView: UITableView!
    
    var titleCellArray: [UITableViewCell] = []
    var colorCellArray: [UITableViewCell] = []
    var widgetCellArray: [UITableViewCell] = []
    
    var addBarButton: UIBarButtonItem!
    var closeBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //cellの設定
        self.tableView.registerNib(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFieldTableViewCell")
        self.tableView.registerNib(UINib(nibName: "LabelTableViewCell", bundle: nil), forCellReuseIdentifier: "LabelTableViewCell")
        self.tableView.registerNib(UINib(nibName: "ColorLabelTableViewCell", bundle: nil), forCellReuseIdentifier: "ColorLabelTableViewCell")
        initCell()
        
        //tableViewの設定
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = ColorController.lightGrayColor()
        //NavigationBarの設定
        self.title = "メモの追加"
        self.navigationController?.navigationBar.barTintColor = ColorController.whiteColor()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Default
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: ColorController.blackColor()]
        
        //NavigationBarのボタンの設定
        let backButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
        
        
        //NavigationBarのボタンの設定
        addBarButton = UIBarButtonItem(image: UIImage(named: "Check"), style: .Done, target: self, action: #selector(EditorViewController.addButtonClicked(_:)))
        addBarButton.enabled = false
        self.navigationItem.rightBarButtonItem = addBarButton
        
        
        closeBarButton = UIBarButtonItem(image: UIImage(named: "Close"), style: .Done, target: self, action: #selector(EditorViewController.closeButtonClicked(_:)))
        closeBarButton.enabled = true
        self.navigationItem.leftBarButtonItem = closeBarButton
        
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
        initCell()
        tableView.reloadData()
        
    }
    
    //セクションの数を設定
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    //セルが選択された時に呼ばれる
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.section {
        case 1:
            let titleCell = titleCellArray[0] as! TextFieldTableViewCell
            ItemController.instance.string = titleCell.inputTextField.text
            performSegueWithIdentifier("MoveToItemColorSelector", sender: nil)
        case 2:
            switch indexPath.row {
            case 0:
                let titleCell = titleCellArray[0] as! TextFieldTableViewCell
                ItemController.instance.string = titleCell.inputTextField.text
                performSegueWithIdentifier("MoveToWidgetEditor", sender: nil)
            default:
                break
            }
        default:
            break
        }
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
    
    //各セクションごとにCellの数を設定
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return titleCellArray.count
        case 1:
            return colorCellArray.count
        case 2:
            return widgetCellArray.count
        default:
            break
        }
        return 0
    }
    
    //tableViewにCellを登録
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return titleCellArray[indexPath.row]
        case 1:
            return colorCellArray[indexPath.row]
        case 2:
            return widgetCellArray[indexPath.row]
        default:
            break
        }
        return UITableViewCell()
    }
    
    //cellの高さを設定
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    //テキストフィールドの入力が終わった時に呼ばれるデリゲートメソッド
    func upDate(canEnable: Bool) {
        addBarButton.enabled = canEnable
    }
    
    //右のボタンが押された時に呼ばれる
    func addButtonClicked(sender: AnyObject) {
        let titleCell = titleCellArray[0] as! TextFieldTableViewCell
        
        if let titleText = titleCell.inputTextField.text {
            //self.navigationController?.popToRootViewControllerAnimated(true)
            
            ////UserDefaultsにScheduleItemを保存してから画面遷移をする
            if let scheduleItem = ItemController.instance.scheduleItem {
                scheduleItem.title = titleText
                scheduleItem.color = ItemController.instance.color!
                
                ItemController.instance.listTableView?.page.items.append(scheduleItem)
                ItemController.instance.listTableView?.tableView.reloadData()
            }
            
            ItemController.instance.scheduleItem = nil
            ItemController.instance.listTableView = nil
            ItemController.instance.color = nil
            ItemController.instance.string = nil
            
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    //閉じるボタンが押された時呼ばれる
    func closeButtonClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //Cellを初期化
    func initCell() {
        
        titleCellArray.removeAll()
        colorCellArray.removeAll()
        widgetCellArray.removeAll()
        
        //section == 0 (titleCellArray)
        //indexPath == 0
        //タイトルを設定するセル
        let titleCell = tableView.dequeueReusableCellWithIdentifier("TextFieldTableViewCell") as! TextFieldTableViewCell
        titleCell.placeholder = "タイトル"
        titleCell.inputTextField.text = ItemController.instance.string
        titleCell.delegate = self
        titleCellArray.append(titleCell)
        
        //section == 1 (colorCellArray)
        //indexPath == 0
        let colorCell = tableView.dequeueReusableCellWithIdentifier("ColorLabelTableViewCell") as! ColorLabelTableViewCell
        colorCell.label?.text = "色"
        colorCell.accessoryType = .DisclosureIndicator
        colorCell.color = ItemController.instance.color!
        colorCellArray.append(colorCell)
        
        //section == 2 (widgetCellArray)
        let editWidgetCell = tableView.dequeueReusableCellWithIdentifier("LabelTableViewCell") as! LabelTableViewCell
        editWidgetCell.accessoryType = .DisclosureIndicator
        editWidgetCell.leftLabel.text = "アイテムの管理"
        widgetCellArray.append(editWidgetCell)
        
        if let scheduleItem = ItemController.instance.scheduleItem {
            for i in 0 ..< scheduleItem.widgets.count {
                let cell = tableView.dequeueReusableCellWithIdentifier("LabelTableViewCell") as! LabelTableViewCell
                cell.leftLabel.text = scheduleItem.widgets[i].cellName
                cell.selectionStyle = .None
                cell.accessoryType = .None
                widgetCellArray.append(cell)
            }
        }
    }
}
