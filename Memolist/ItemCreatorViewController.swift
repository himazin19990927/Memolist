//
//  ItemCreatorViewController.swift
//  Memolist
//
//  Created by 原田大樹 on 2016/09/19.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

//
//  ColorSelectorViewController.swift
//  To Do List
//
//  Created by 原田大樹 on 2016/08/24.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import Foundation
import UIKit

class ItemCreatorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
    
    var titleCells: [UITableViewCell] = []
    var colorSelectorCells: [UITableViewCell] = []
    var itemSelectorCells: [UITableViewCell] = []
    
    
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
        self.title = "アイテムの追加"
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
        
        //セルの設定
        initCell()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        //viewが表示される前にcellの色を替える
        let colorLabelCell = colorSelectorCells[0] as! ColorLabelTableViewCell
        if let color = ItemController.instance.color {
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
            //MoveToItemColorSelector
            
            performSegueWithIdentifier("MoveToItemColorSelector", sender: nil)
            break
        case 2:
            //itemSelectorCells
            switch indexPath.row {
            case 0:
                ItemController.instance.itemType = ItemType.Memo
            case 1:
                ItemController.instance.itemType = ItemType.Counter
            default:
                ItemController.instance.itemType = ItemType.None
            }
            
            changeAccessoryType()
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
            //itemSelectorCells
            return itemSelectorCells.count
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
            //itemSelectorCells
            return itemSelectorCells[indexPath.row]
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
    
    //cellの高さを設定
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    
    func initCell() {
        titleCells.removeAll()
        colorSelectorCells.removeAll()
        itemSelectorCells.removeAll()
        
        //section == 0 (titleCells)
        //indexPath == 0
        //タイトルを設定するセル
        let titleCell = tableView.dequeueReusableCellWithIdentifier("TextFieldTableViewCell") as! TextFieldTableViewCell
        
        titleCell.textField.text = ""
        
        titleCell.placeholder = "タイトル"
        titleCells.append(titleCell)
        
        //section == 1 (colorSelectorCells)
        //indexPath == 0
        //色を設定するセル
        let colorLabelCell = tableView.dequeueReusableCellWithIdentifier("ColorLabelTableViewCell") as! ColorLabelTableViewCell
        colorLabelCell.label.text = "色"
        colorLabelCell.accessoryType = .DisclosureIndicator
        
        if let page = ItemController.instance.page {
            colorLabelCell.color = page.color
        } else {
            colorLabelCell.color = UIColor.blackColor()
        }
        
        colorSelectorCells.append(colorLabelCell)
        
        //section == 2(itemSelectorCells)
        //itemTypeを設定する
        let memoLabelCell = tableView.dequeueReusableCellWithIdentifier("LabelTableViewCell") as! LabelTableViewCell
        memoLabelCell.leftLabel.text = "メモ"
        itemSelectorCells.append(memoLabelCell)
        
        let counterLabelCell = tableView.dequeueReusableCellWithIdentifier("LabelTableViewCell") as! LabelTableViewCell
        counterLabelCell.leftLabel.text = "カウンター"
        itemSelectorCells.append(counterLabelCell)
        
        changeAccessoryType()
    }
    
    func closeButtonClicked(sender: AnyObject) {
        ItemController.instance.page = nil
        ItemController.instance.color = nil
        ItemController.instance.itemType = nil
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addButtonClicked(sender: AnyObject) {
        let itemController = ItemController.instance
        let titleCell = titleCells[0] as! TextFieldTableViewCell
        
        if let itemType = itemController.itemType {
            switch itemType {
            case .Memo:
                let memo = Memo()
                memo.text = titleCell.textField.text!
                memo.color = itemController.color!
                
                itemController.page?.items.append(memo)
            
            case .Counter:
                let counter = Counter()
                counter.text = titleCell.textField.text!
                counter.color = itemController.color!
                
                itemController.page?.items.append(counter)
            default:
                break
            }
        }
        
        ItemController.instance.page = nil
        ItemController.instance.color = nil
        ItemController.instance.itemType = nil
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func changeAccessoryType() {
        for cell in itemSelectorCells {
            cell.accessoryType = .None
        }
        
        if let itemType = ItemController.instance.itemType {
            switch itemType {
            case .Memo:
                itemSelectorCells[0].accessoryType = .Checkmark
            case .Counter:
                itemSelectorCells[1].accessoryType = .Checkmark
            default:
                break
            }
        }
    }

}





























