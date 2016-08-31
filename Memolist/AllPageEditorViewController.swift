//
//  AllPageEditorViewController.swift
//  To Do List
//
//  Created by 原田大樹 on 2016/08/24.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import Foundation
import UIKit

class AllPageEditorViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
    
    var pageCellArray: [UITableViewCell] = []
    
    var doneBarButton: UIBarButtonItem!
    var addBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableviewの設定
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = ColorController.lightGrayColor()
        
        //NavigationBarの設定
        self.title = "ページ設定"
        self.navigationController?.navigationBar.barTintColor = ColorController.whiteColor()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Default
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: ColorController.blackColor()]
        
        //NavigationBarのボタンの設定
        let backButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
        
        doneBarButton = UIBarButtonItem(image: UIImage(named: "Close"), style: .Done, target: self, action: #selector(AllPageEditorViewController.doneButtonClicked(_:)))
        
        addBarButton = UIBarButtonItem(image: UIImage(named: "Add"), style: .Done, target: self, action: #selector(AllPageEditorViewController.addButtonClicked(_:)))
        
        self.navigationItem.rightBarButtonItem = doneBarButton
        self.navigationItem.setLeftBarButtonItems([editButtonItem(), addBarButton], animated: true)
        
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
        self.tableView.registerNib(UINib(nibName: "ColorLabelTableViewCell", bundle: nil), forCellReuseIdentifier: "ColorLabelTableViewCell")
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
    
    //セクションの数を設定
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //セルが選択された時に呼ばれる
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if let viewController = ItemController.instance.viewController {
            let listTableViewController = viewController.controllerArray[indexPath.row] as? ListTableViewController
            let itemController = ItemController.instance
            
            itemController.page = listTableViewController?.page
            itemController.string = itemController.page?.title
            itemController.color = itemController.page?.color.copy() as? UIColor
            performSegueWithIdentifier("MoveToPageEditor", sender: nil)
        }        
    }
    
    //セルの数を設定
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.pageArray.count
    }
    
    //セルを設定
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return pageCellArray[indexPath.row]
    }
    
    //削除できるかを設定
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    //移動できるかを設定
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    //セルが移動された時に呼ばれる
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let targetCell = pageCellArray[sourceIndexPath.row]
        if let index = pageCellArray.indexOf(targetCell) {
            pageCellArray.removeAtIndex(index)
            pageCellArray.insert(targetCell, atIndex: destinationIndexPath.row)
            
            
            //appDelegate側にも反映
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let targetPage = appDelegate.pageArray[index]
            appDelegate.pageArray.removeAtIndex(index)
            appDelegate.pageArray.insert(targetPage, atIndex: destinationIndexPath.row)
            
            if let viewController = ItemController.instance.viewController {
                viewController.initPageMenu()
            }
        }
        
        
    }
    
    //編集モードに切り替え
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated: animated)
        doneBarButton.enabled = !editing
    }
    
    
    //セルを削除されるときに呼ばれる
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if appDelegate.pageArray.count - 1  == 0 {
            //セルを消去した時合計ページ数が0個になる時アラートを表示
            let alert = UIAlertController(title: "ページを消せません", message: "すべてのページを消すことはできません", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            
            alert.addAction(action)
            
            presentViewController(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "ページを消してもいいですか?", message: "ページ内のアイテムはすべて消去されます", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "キャンセル", style: .Default, handler: nil)
            let okAction = UIAlertAction(title: "OK", style: .Default) { action in
                appDelegate.pageArray[indexPath.row].removeObject()
                appDelegate.pageArray.removeAtIndex(indexPath.row)
                
                tableView.deleteRowsAtIndexPaths([NSIndexPath(forItem: indexPath.row, inSection: indexPath.section)], withRowAnimation: UITableViewRowAnimation.Fade)
                
                if let viewController = ItemController.instance.viewController {
                    viewController.initPageMenu()
                }
            }
            
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            
            presentViewController(alert, animated: true, completion: nil)

        }
    }
    
    func initCell() {
        pageCellArray.removeAll()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let pageArray = appDelegate.pageArray
        
        for page in pageArray {
            let pageCell = tableView.dequeueReusableCellWithIdentifier("ColorLabelTableViewCell") as! ColorLabelTableViewCell
            pageCell.label?.text = page.title
            pageCell.color = page.color
            pageCell.accessoryType = .DisclosureIndicator
            pageCellArray.append(pageCell)
        }
    }
    
    func doneButtonClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addButtonClicked(sender: AnyObject) {
        let page = Page()
        let colorArray = [
            ColorController.redColor(),
            ColorController.orangeColor(),
            ColorController.greenColor(),
            ColorController.blueColor(),
            ColorController.purpleColor()
        ]
        
        //32bit環境だとキャスト時に落ちるので別で処理
        let index = arc4random() % UInt32(colorArray.count)
        
        page.color = colorArray[Int(index)]
        page.title = "新しいリスト"
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.pageArray.append(page)
        
        if let viewController = ItemController.instance.viewController {
            viewController.initPageMenu()
        }
        
        initCell()
        tableView.reloadData()
    }
    
    
}




















