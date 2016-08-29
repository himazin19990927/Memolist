//
//  ColorSelectorViewController.swift
//  To Do List
//
//  Created by 原田大樹 on 2016/08/24.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import Foundation
import UIKit

class ItemColorSelectorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
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
        
        //セルの初期化
        self.tableView.registerNib(UINib(nibName: "ColorSelectTableViewCell", bundle: nil), forCellReuseIdentifier: "ColorSelectTableViewCell")
        self.tableView.registerNib(UINib(nibName: "LabelTableViewCell", bundle: nil), forCellReuseIdentifier: "LabelTableViewCell")
        initCell()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //セクションの数を設定
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return colorCellArray.count
    }
    
    //セルが選択された時に呼ばれる
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let colorCell = colorCellArray[indexPath.section] as! ColorSelectTableViewCell
        ItemController.instance.color = colorCell.color
        navigationController?.popViewControllerAnimated(true)
    }
    
    //セルの数を設定
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //セルを設定
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return colorCellArray[indexPath.section]
    }
    
    //cellの高さを設定
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    
    func initCell() {
        colorCellArray.removeAll()
        
        let colorList = ColorController.colorList
        //colorList.insert(ColorController.whiteColor(), atIndex: 0)
        for color in colorList {
            let cell = tableView.dequeueReusableCellWithIdentifier("ColorSelectTableViewCell") as! ColorSelectTableViewCell
            cell.color = color
            colorCellArray.append(cell)
        }
        
    }
}






















