//
//  ColorSelectorViewController.swift
//  To Do List
//
//  Created by 原田大樹 on 2016/08/24.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import Foundation
import UIKit

class ColorSelectorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
    
    var colorCellArray: [UITableViewCell] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableviewの設定
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = ColorController.lightGrayColor()
        tableView.separatorColor = UIColor.clearColor()
        
        //NavigationBarの設定
        self.title = "色の選択"
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
        self.tableView.registerNib(UINib(nibName: "ColorSelectTableViewCell", bundle: nil), forCellReuseIdentifier: "ColorSelectTableViewCell")
        
        //セルの設定
        initCell()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //セクションの数を設定
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return colorCellArray.count + 1
    }
    
    //セルが選択された時に呼ばれる
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.section {
        case 0:
            break
        default:
            let colorCell = colorCellArray[indexPath.section - 1] as! ColorSelectTableViewCell
            ItemController.instance.color = colorCell.color
            navigationController?.popViewControllerAnimated(true)

        }
    }
    
    //セルの数を設定
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            break
        default:
            return 1
        }
        return 0
    }
    
    //セルを設定
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            break
        default:
            return colorCellArray[indexPath.section - 1]
        }
        return UITableViewCell()
    }
    
    //headerのUIViewを設定
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = ColorController.lightGrayColor()
        return view
    }
    
    //headerの高さを設定
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
//    //footerのUIViewを設定
//    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let view = UIView()
//        view.backgroundColor = ColorController.lightGrayColor()
//        return view
//    }
//    
//    //footerの高さを設定
//    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0
//    }
    
    //cellの高さを設定
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }

    
    func initCell() {
        colorCellArray.removeAll()
        
        let colorList = ColorController.colorList
        
        for color in colorList {
            let cell = tableView.dequeueReusableCellWithIdentifier("ColorSelectTableViewCell") as! ColorSelectTableViewCell
            cell.color = color
            colorCellArray.append(cell)
        }
    }
}



import Foundation
