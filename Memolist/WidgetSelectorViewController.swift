//
//  WidgetEditorViewController.swift
//  To Do List
//
//  Created by 原田大樹 on 2016/08/11.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import Foundation
import UIKit

class WidgetSelectorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
    
    var widgetCellArray: [UITableViewCell] = []
    
    var closeBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableviewの設定
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = ColorController.lightGrayColor()
        
        //NavigationBarの設定
        self.title = "アイテムの追加"
        self.navigationController?.navigationBar.barTintColor = ColorController.whiteColor()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Default
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: ColorController.blackColor()]
        
        //NavigationBarのボタンの設定
        closeBarButton = UIBarButtonItem(image: UIImage(named: "Close"), style: .Done, target: self, action: #selector(WidgetSelectorViewController.closeButtonClicked(_:)))
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
        
        //セルの初期化
        self.tableView.registerNib(UINib(nibName: "LabelTableViewCell", bundle: nil), forCellReuseIdentifier: "LabelTableViewCell")
        initCell()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //セクションの数を設定
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //セルが選択された時に呼ばれる
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let scheduleItem = ItemController.instance.scheduleItem {
            switch indexPath.row {
            case 0:
                scheduleItem.widgets.append(Label())
            case 1:
                scheduleItem.widgets.append(Counter())
            default:
                break
            }
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    //セルの数を設定
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return widgetCellArray.count
    }
    
    //セルを設定
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return widgetCellArray[indexPath.row]
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
    
    func initCell() {
        //Check
        //row == 0
        let labelCell = tableView.dequeueReusableCellWithIdentifier("LabelTableViewCell") as! LabelTableViewCell
        labelCell.leftLabel.text = "ラベル"
        labelCell.accessoryType = .DisclosureIndicator
        widgetCellArray.append(labelCell)
        
        //row == 1
        let counterCell = tableView.dequeueReusableCellWithIdentifier("LabelTableViewCell") as! LabelTableViewCell
        counterCell.leftLabel.text = "カウンター"
        counterCell.accessoryType = .DisclosureIndicator
        widgetCellArray.append(counterCell)
    }
    
    func closeButtonClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}





























