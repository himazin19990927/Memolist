//
//  WidgetEditorViewController.swift
//  To Do List
//
//  Created by 原田大樹 on 2016/08/11.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import Foundation
import UIKit

class WidgetEditorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
    
    var widgetArray: [UITableViewCell] = []
    
    var addBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableviewの設定
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = ColorController.lightGrayColor()
        
        //NavigationBarのボタンの設定
        let backButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
        
        addBarButton = UIBarButtonItem(image: UIImage(named: "Add"), style: .Done, target: self, action: #selector(WidgetEditorViewController.addButtonClicked(_:)))
        self.navigationItem.setRightBarButtonItems([editButtonItem(), addBarButton], animated: true)
        
        //NavigationBarの設定
        
        self.title = "アイテムの管理"
        self.navigationController?.navigationBar.barTintColor = ColorController.whiteColor()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Default
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: ColorController.blackColor()]
        
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
        
        //テスト:セルの初期化
        self.tableView.registerNib(UINib(nibName: "LabelTableViewCell", bundle: nil), forCellReuseIdentifier: "LabelTableViewCell")
        initCell()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //viewが表示される直前に呼ばれる
    override func viewWillAppear(animated: Bool) {
        initCell()
        tableView.reloadData()
    }
    
    //セクションの数を設定
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //セルが選択された時に呼ばれる
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //セルの数を設定
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return widgetArray.count
    }
    
    //セルを設定
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return widgetArray[indexPath.row]
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
    
    //セルが削除できるかどうか設定
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if ItemController.instance.scheduleItem?.widgets.count != 0 {
            return true
        } else {
            return false
        }
    }
    
    //セルを削除するときに呼ばれる
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let scheduleItem = ItemController.instance.scheduleItem
        
        Widget.removeWidget(scheduleItem!.widgets[indexPath.row])
        
        scheduleItem?.widgets.removeAtIndex(indexPath.row)
        widgetArray.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([NSIndexPath(forItem: indexPath.row, inSection: indexPath.section)], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    
    //セルが並び替えられるかどうか設定
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if ItemController.instance.scheduleItem?.widgets.count != 0 {
            return true
        } else {
            return false
        }
    }
    
    //セルが並び替えられるときに呼ばれる
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let scheduleItem = ItemController.instance.scheduleItem
        let targetItem = scheduleItem?.widgets[sourceIndexPath.row]
        scheduleItem?.widgets.removeAtIndex(sourceIndexPath.row)
        scheduleItem?.widgets.insert(targetItem!, atIndex: destinationIndexPath.row)
    }
    
    func initCell() {
        widgetArray.removeAll()
        
        if let scheduleItem = ItemController.instance.scheduleItem {
            if scheduleItem.widgets.count == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("LabelTableViewCell") as! LabelTableViewCell
                cell.leftLabel.text = "アイテムがありません"
                cell.selectionStyle = .None
                cell.accessoryType = .None
                widgetArray.append(cell)
            } else {
                for i in 0 ..< scheduleItem.widgets.count {
                    let cell = tableView.dequeueReusableCellWithIdentifier("LabelTableViewCell") as! LabelTableViewCell
                    cell.leftLabel.text = scheduleItem.widgets[i].cellName
                    cell.selectionStyle = .None
                    cell.accessoryType = .None
                    widgetArray.append(cell)
                }
            }
        }
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        addBarButton.enabled = !editing
        tableView.editing = editing
    }
    
    //addボタンが押された時呼ばれる
    func addButtonClicked(sender: AnyObject) {
        let alert = UIAlertController(title: "アイテムの追加", message: nil, preferredStyle: .ActionSheet)
        
        let cancel = UIAlertAction(title: "キャンセル", style: .Cancel, handler: nil)
        alert.addAction(cancel)
        
        //check
        let addLabel = UIAlertAction(title: "ラベル", style: .Default, handler: {
            (action: UIAlertAction!) in
            ItemController.instance.scheduleItem!.widgets.append(Label())
            self.initCell()
            self.tableView.reloadData()
        })
        alert.addAction(addLabel)
        
        let addToDo = UIAlertAction(title: "チェックボックス", style: .Default, handler: {
            (action: UIAlertAction!) in
            ItemController.instance.scheduleItem!.widgets.append(ToDo())
            self.initCell()
            self.tableView.reloadData()
        })
        alert.addAction(addToDo)
        
        let addCounter = UIAlertAction(title: "カウンター", style: .Default, handler: {
            (action: UIAlertAction!) in
            ItemController.instance.scheduleItem!.widgets.append(Counter())
            self.initCell()
            self.tableView.reloadData()
        })
        alert.addAction(addCounter)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

}


























