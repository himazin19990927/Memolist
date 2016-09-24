//
//  PageCreatorViewController.swift
//  Memolist
//
//  Created by 原田大樹 on 2016/09/22.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import Foundation
import UIKit

class PageCreatorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
    
    var titleCells: [UITableViewCell] = []
    var colorCells: [UITableViewCell] = []
    
    var addBarButton: UIBarButtonItem!
    var closeBarButton: UIBarButtonItem!
    
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
        tableView.separatorColor = ColorController.blueGrayColor()
        
        //NavigationBarの設定
        self.title = "リストの追加"
        self.navigationController?.navigationBar.barTintColor = ColorController.whiteColor()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Default
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: ColorController.blackColor()]
        
        //NavigationBarのボタンの設定
        let backButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
        
        closeBarButton = UIBarButtonItem(image: UIImage(named: "Close"), style: .Done, target: self, action: #selector(PageCreatorViewController.closeButton(_:)))
        closeBarButton.enabled = true
        self.navigationItem.leftBarButtonItem = closeBarButton

        
        addBarButton = UIBarButtonItem(image: UIImage(named: "Check"), style: .Done, target: self, action: #selector(PageCreatorViewController.addButton(_:)))
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
    
    override func viewWillAppear(animated: Bool) {
        if let color = PageController.instance.pageBuf?.color {
            let colorCell = colorCells[0] as! ColorLabelTableViewCell
            colorCell.color = color
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        let titleCell = titleCells[0] as! TextFieldTableViewCell
        titleCell.textField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        let titleCell = titleCells[0] as! TextFieldTableViewCell
        titleCell.textField.endEditing(true)
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
            
            performSegueWithIdentifier("MoveToColorSelector", sender: nil)
        default:
            break
        }
    }
    
    //セルの数を設定
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return titleCells.count
        case 1:
            return colorCells.count
        default:
            break
        }
        return 0
    }
    
    //セルを設定
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return titleCells[indexPath.row]
        case 1:
            return colorCells[indexPath.row]
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
        titleCells.removeAll()
        colorCells.removeAll()
        
        //section == 0 (titleCells)
        //indexPath == 0
        //タイトルを設定するセル
        let titleCell = tableView.dequeueReusableCellWithIdentifier("TextFieldTableViewCell") as! TextFieldTableViewCell
        titleCell.textField.text = PageController.instance.pageBuf?.title
        titleCell.placeholder = "タイトル"
        titleCells.append(titleCell)
        
        //section == 1
        let colorCell = tableView.dequeueReusableCellWithIdentifier("ColorLabelTableViewCell") as! ColorLabelTableViewCell
        colorCell.label!.text = "色"
        colorCell.accessoryType = .DisclosureIndicator
        if let color = PageController.instance.pageBuf?.color {
            colorCell.color = color
        }
        colorCells.append(colorCell)
        
    }
    
    //右のボタンが押された時に呼ばれる
    func closeButton(sender: AnyObject) {
        PageController.instance.pageBuf = nil
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addButton(sender:AnyObject) {
        let titleCell = titleCells[0] as! TextFieldTableViewCell
        if let text = titleCell.textField.text {
            if text.characters.count >= 15 {
                //タイトルが15文字以上だった場合アラートを表示
                let alert = UIAlertController(title: "タイトルが長過ぎます", message: nil, preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                
                alert.addAction(action)
                
                presentViewController(alert, animated: true, completion: nil)
            } else if text.characters.isEmpty {
                //タイトルが15文字以上だった場合アラートを表示
                let alert = UIAlertController(title: "タイトルを入力してください", message: nil, preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                
                alert.addAction(action)
                
                presentViewController(alert, animated: true, completion: nil)
                
            } else {
                //タイトルが正しく入力されていれば画面を遷移
                let page = PageController.instance.pageBuf!
                
                
                //textを設定
                page.title = text
                
                PageController.instance.pageBuf = nil
                
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.pageArray.append(page)
                
                if let viewController = AppController.instance.viewController {
                    viewController.initPageMenu()
                }
                
                dismissViewControllerAnimated(true, completion: nil)
                
            }
        }
    }

}
