//
//  WidgetEditorViewController.swift
//  To Do List
//
//  Created by 原田大樹 on 2016/08/11.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import Foundation
import UIKit

class PageEditorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TextFieldCellDelegate{
    @IBOutlet var tableView: UITableView!
    
    var titleCellArray: [UITableViewCell] = []
    var colorCellArray: [UITableViewCell] = []
    
    var addBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //セルの初期化
        self.tableView.registerNib(UINib(nibName: "LabelTableViewCell", bundle: nil), forCellReuseIdentifier: "LabelTableViewCell")
        self.tableView.registerNib(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFieldTableViewCell")
        self.tableView.registerNib(UINib(nibName: "ColorLabelTableViewCell", bundle: nil), forCellReuseIdentifier: "ColorLabelTableViewCell")
        initCell()
        
        
        //tableviewの設定
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = ColorController.lightGrayColor()
        
        //NavigationBarの設定
        self.title = ItemController.instance.page?.title
        self.navigationController?.navigationBar.barTintColor = ColorController.whiteColor()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Default
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: ColorController.blackColor()]
        
        //NavigationBarのボタンの設定
        let backButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
        
        addBarButton = UIBarButtonItem(image: UIImage(named: "Check"), style: .Done, target: self, action: #selector(PageEditorViewController.addButtonClicked(_:)))
        addBarButton.enabled = true
        self.navigationItem.rightBarButtonItem = addBarButton
        
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
    }
    
    //viewが表示される直前に呼ばれる
    override func viewWillAppear(animated: Bool) {
        initCell()
        tableView.reloadData()
        
    }
    
    //セクションの数を設定
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    //セルが選択された時に呼ばれる
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.section {
        case 0:
            break
        case 1:
            let titleCell = titleCellArray[0] as! TextFieldTableViewCell
            ItemController.instance.string = titleCell.inputTextField.text
            performSegueWithIdentifier("MoveToColorSelector", sender: nil)
        default:
            break
        }
    }
    
    //セルの数を設定
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return titleCellArray.count
        case 1:
            return colorCellArray.count
        default:
            break
        }
        return 0
    }
    
    //セルを設定
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return titleCellArray[indexPath.row]
        case 1:
            return colorCellArray[indexPath.row]
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
    
    func upDate(canEnable: Bool) {
        //addBarButton.enabled = canEnable
    }
    func initCell() {
        titleCellArray.removeAll()
        colorCellArray.removeAll()
        
        //section == 0 (titleCellArray)
        //indexPath == 0
        //タイトルを設定するセル
        let titleCell = tableView.dequeueReusableCellWithIdentifier("TextFieldTableViewCell") as! TextFieldTableViewCell
        titleCell.inputTextField.text = ItemController.instance.string
        titleCell.placeholder = "タイトル(必須)"
        titleCell.maxLength = 15
        titleCell.delegate = self
        titleCellArray.append(titleCell)
        
        //section == 1
        let colorCell = tableView.dequeueReusableCellWithIdentifier("ColorLabelTableViewCell") as! ColorLabelTableViewCell
        colorCell.label!.text = "色"
        colorCell.accessoryType = .DisclosureIndicator
        if let color = ItemController.instance.color {
            colorCell.color = color
        }
        colorCellArray.append(colorCell)
        
    }
    
    //右のボタンが押された時に呼ばれる
    func addButtonClicked(sender:AnyObject) {
        let titleCell = titleCellArray[0] as! TextFieldTableViewCell
        if let text = titleCell.inputTextField.text {
            if !text.isEmpty {
                if text.characters.count > 14 {
                    //タイトルが15文字以上だった場合アラートを表示
                    let alert = UIAlertController(title: "タイトルが長過ぎます", message: "文字数を14文字以下にしてください", preferredStyle: .Alert)
                    let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    
                    alert.addAction(action)
                    
                    presentViewController(alert, animated: true, completion: nil)
                } else {
                    //タイトルが正しく入力されていれば画面を遷移
                    let itemController = ItemController.instance
                    
                    itemController.page?.title = text
                    if let color = itemController.color {
                        itemController.page?.color = color
                    }
                    
                    itemController.page = nil
                    
                    if let viewController = ItemController.instance.viewController {
                        viewController.initPageMenu()
                    }
                    
                    navigationController?.popViewControllerAnimated(true)
                }
            } else {
                //タイトルが入力されていない場合アラートを表示
                let alert = UIAlertController(title: "未入力の項目", message: "タイトルを入力してください", preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                
                alert.addAction(action)
                
                presentViewController(alert, animated: true, completion: nil)
            }
        }
        
    }
}

