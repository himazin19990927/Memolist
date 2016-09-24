//
//  MemoEditorViewController.swift
//  Memolist
//
//  Created by 原田大樹 on 2016/09/20.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import Foundation
import UIKit

class MemoEditorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
    
    var titleCells: [UITableViewCell] = []
    var colorSelectorCells: [UITableViewCell] = []
    var textCells: [UITableViewCell] = []
    
    var closeBarButton: UIBarButtonItem!
    var addBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableviewの設定
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = ColorController.lightGrayColor()
        tableView.separatorColor = ColorController.blueGrayColor()
        
        //NavigationBarの設定
        self.title = "メモの編集"
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
        
        //テスト:セルの初期化
        self.tableView.registerNib(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFieldTableViewCell")
        self.tableView.registerNib(UINib(nibName: "ColorLabelTableViewCell", bundle: nil), forCellReuseIdentifier: "ColorLabelTableViewCell")
        self.tableView.registerNib(UINib(nibName: "LabelTableViewCell", bundle: nil), forCellReuseIdentifier: "LabelTableViewCell")
        self.tableView.registerNib(UINib(nibName: "TextViewTableViewCell", bundle: nil), forCellReuseIdentifier: "TextViewTableViewCell")
        
        //セルの設定
        initCell()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        //viewが表示される前にcellの色を替える
        let colorLabelCell = colorSelectorCells[0] as! ColorLabelTableViewCell
        if let color = MemoController.instance.memoBuf?.color {
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
        
        let textCell = textCells[0] as! TextViewTableViewCell
        textCell.textView.endEditing(true)
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
            performSegueWithIdentifier("MoveToMemoColorSelector", sender: nil)
            break
        case 2:
            //textCells
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
            //textCells
            return textCells.count
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
            //textCells
            return textCells[indexPath.row]
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
            return 170
        }
        
        return 50
    }
    
    
    func initCell() {
        titleCells.removeAll()
        colorSelectorCells.removeAll()
        
        //section == 0 (titleCells)
        //indexPath == 0
        //タイトルを設定するセル
        let titleCell = tableView.dequeueReusableCellWithIdentifier("TextFieldTableViewCell") as! TextFieldTableViewCell
        titleCell.textField.text = MemoController.instance.memoBuf!.text
        titleCell.placeholder = "タイトル"
        titleCells.append(titleCell)
        
        //section == 1 (colorSelectorCells)
        //indexPath == 0
        //色を設定するセル
        let colorLabelCell = tableView.dequeueReusableCellWithIdentifier("ColorLabelTableViewCell") as! ColorLabelTableViewCell
        colorLabelCell.label.text = "色"
        colorLabelCell.accessoryType = .DisclosureIndicator
        
        colorSelectorCells.append(colorLabelCell)
        
        //section == 2 (textCells)
        let textCell = tableView.dequeueReusableCellWithIdentifier("TextViewTableViewCell") as! TextViewTableViewCell
        textCell.textView.text = MemoController.instance.memoBuf!.memo
        textCells.append(textCell)
        
    }
    
    func closeButtonClicked(sender: AnyObject) {
        MemoController.instance.memo = nil
        MemoController.instance.memoBuf = nil
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addButtonClicked(sender: AnyObject) {
        let memo = MemoController.instance.memo!
        
        let titleCell = titleCells[0] as! TextFieldTableViewCell
        memo.text = titleCell.textField.text!
        
        let memoBuf = MemoController.instance.memoBuf!
        memo.color = memoBuf.color
        
        let textCell = textCells[0] as! TextViewTableViewCell
        memo.memo = textCell.textView.text
        
        MemoController.instance.memo = nil
        MemoController.instance.memoBuf = nil
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}

















