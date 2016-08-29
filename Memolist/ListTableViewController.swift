//
//  ListTableViewController.swift
//  To Do List
//
//  Created by 原田大樹 on 2016/05/28.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import UIKit

protocol ListTableViewDelegate {
    func editWidget(widgetType: WidgetType)
    func editMemo(memo: ScheduleItem)
}

class ListTableViewController: UITableViewController, ListTableViewCellDelegate{
    var delegate: ListTableViewDelegate!
    var listItemArray: [ListItem] = []
    
    var closeMemo: Bool = false
    
    var page: Page = Page() {
        willSet {
            self.title = newValue.title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let clearView:UIView = UIView(frame: CGRectZero)
        clearView.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = clearView
        tableView.tableHeaderView = clearView
        
        scrollEnabled()
        
        //セルの初期化
        //Check
        self.tableView.registerNib(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "ListTableViewCell")
        self.tableView.registerNib(UINib(nibName: "LabelTableViewCell", bundle: nil), forCellReuseIdentifier: "LabelTableViewCell")
        self.tableView.registerNib(UINib(nibName: "LabelCell", bundle: nil), forCellReuseIdentifier: "LabelCell")
        self.tableView.registerNib(UINib(nibName: "DateLabelCell", bundle: nil), forCellReuseIdentifier: "DateLabelCell")
        self.tableView.registerNib(UINib(nibName: "CounterCell", bundle: nil), forCellReuseIdentifier: "CounterCell")
        initCell()
    }
    
    override func viewWillAppear(animated: Bool) {
        scrollEnabled()
        initCell()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    //セクションの数を設定
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return listItemArray.count
    }

    //セクションごとのセルの数を設定
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listItemArray[section].cellArray.count
    }

    //セルを設定
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return listItemArray[indexPath.section].cellArray[indexPath.row]
    }
    
    //セルの高さを設定
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 64.0
        }
        
        //cellを表示させない時は高さを0にし、hiddenをtrueにする
        if !page.items[indexPath.section].open || closeMemo {
            listItemArray[indexPath.section].cellArray[indexPath.row].hidden = true
            
            //Check
            let widget = page.items[indexPath.section].widgets[indexPath.row - 1]
            switch widget.widgetType {
            case .Label:
                let labelCell = listItemArray[indexPath.section].cellArray[indexPath.row] as! LabelCell
                labelCell.open = false
            case .Counter:
                let counterCell = listItemArray[indexPath.section].cellArray[indexPath.row] as! CounterCell
                counterCell.open = false
            default:
                break
            }
            
            return 0
        } else {
            let widget = page.items[indexPath.section].widgets[indexPath.row - 1]
            switch widget.widgetType {
            case .Label:
                let labelCell = listItemArray[indexPath.section].cellArray[indexPath.row] as! LabelCell
                labelCell.open = true
            case .Counter:
                let counterCell = listItemArray[indexPath.section].cellArray[indexPath.row] as! CounterCell
                counterCell.open = true
            default:
                break
            }

            
            listItemArray[indexPath.section].cellArray[indexPath.row].hidden = false
            return CGFloat(widget.height)
        }
    }
    
    //セルが削除できるかどうか設定
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.row == 0 {
            return true
        }
        return false
    }
    
    //セルが削除されるときに呼ばれる
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        page.items[indexPath.section].removeObject()
        page.items.removeAtIndex(indexPath.section)
        
        listItemArray.removeAtIndex(indexPath.section)
        tableView.deleteSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
        
    }
    
    //セルが並び替えられるかどうか設定
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.row == 0 {
            return true
        } else {
            return false
        }
    }
    
    //セルが移動された時に呼ばれる
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let target = listItemArray[sourceIndexPath.section]
        listItemArray.removeAtIndex(sourceIndexPath.section)
        listItemArray.insert(target, atIndex: destinationIndexPath.section)
        
        //appDelegate側にも反映
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let pageIndex = ItemController.instance.viewController?.pageMenu?.currentPageIndex
        let targetItem = appDelegate.pageArray[pageIndex!].items[sourceIndexPath.section]
        appDelegate.pageArray[pageIndex!].items.removeAtIndex(sourceIndexPath.section)
        appDelegate.pageArray[pageIndex!].items.insert(targetItem, atIndex: destinationIndexPath.section)
        
        initCell()
        tableView.reloadData()

    }

    
    //セルが選択された時に呼ばれる
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.row {
        case 0:
            //セルの中にアイテムがあるときだけ開く
            if listItemArray[indexPath.section].cellArray.count > 1 {
                tableView.beginUpdates()
                if page.items[indexPath.section].open {
                    let listCell = listItemArray[indexPath.section].cellArray[0] as! ListTableViewCell
                    listCell.titleLabel.textColor = ColorController.blackColor()
                    page.items[indexPath.section].open = false
                } else {
                    let listCell = listItemArray[indexPath.section].cellArray[0] as! ListTableViewCell
                    listCell.titleLabel.textColor = UIColor.redColor()
                    page.items[indexPath.section].open = true
                    
                }
                tableView.endUpdates()
            }
        default:
            let widget = page.items[indexPath.section].widgets[indexPath.row - 1]
            switch widget.widgetType {
            case .Label:
                ItemController.instance.item = widget
                delegate.editWidget(.Label)
            default:
                break
            }
            break
        }
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        
        super.setEditing(editing, animated: animated)
        
        tableView.beginUpdates()
        closeMemo = editing
        tableView.endUpdates()
        tableView.editing = editing
        
    }
    
    //セルが存在しない場合スクロールを禁止する
    func scrollEnabled() {
        if page.items.isEmpty {
            self.tableView.scrollEnabled = false
        } else {
            self.tableView.scrollEnabled = true
        }
    }
    
    //ページ設定の更新
    func reloadPage() {
        self.title = page.title
    }
    
    func initCell() {
        listItemArray.removeAll()
        for item in page.items {
            let listItem = ListItem()
            
            //メモの最初のセルを追加
            let listCell = tableView.dequeueReusableCellWithIdentifier("ListTableViewCell") as! ListTableViewCell
            listCell.setItem(item)
            listCell.selectionStyle = .None
            listCell.delegate = self
            
            if item.open {
                listCell.titleLabel.textColor = UIColor.redColor()
            } else {
                listCell.titleLabel.textColor = UIColor.blackColor()
            }
            
            listItem.cellArray.append(listCell)
            
            //Check
            for widget in item.widgets {
                //ウィジェットのセルを追加
                switch widget.widgetType {
                case .Label:
                    
                    let label = widget as! Label
                    let labelCell = tableView.dequeueReusableCellWithIdentifier("LabelCell") as! LabelCell
                    
                    labelCell.color = item.color
                    labelCell.label.text = label.text
                    if let date = label.date {
                        let formatter = NSDateFormatter()
                        let format = "MM/dd HH:mm"
                        formatter.dateFormat = format
                        labelCell.dateLabel.text = formatter.stringFromDate(date)
                    } else {
                        labelCell.dateLabel.text = ""
                    }
                    
                    listItem.cellArray.append(labelCell)
                case .Counter:
                    let counter = widget as! Counter
                    let counterCell = tableView.dequeueReusableCellWithIdentifier("CounterCell") as! CounterCell
                    counterCell.counter = counter
                    counterCell.color = item.color
                    listItem.cellArray.append(counterCell)
                default:
                    break
                }
            }
            
            listItemArray.append(listItem)
        }
        
    }
    
    func saveWidget() {
        for section in 0 ..< listItemArray.count {
            for row in 0 ..< listItemArray[section].cellArray.count {
                //ウィジェットを増やすとここを変える
                if row == 0 {
                    //rowがゼロのときはウィジェットではないのでスキップ
                    continue
                }
                
                let widget = page.items[section].widgets[row - 1]
                switch widget.widgetType {
                case .Label:
                    break
                default:
                    break
                }
            }
        }
    }
    
    func editMemo(item: ScheduleItem) {
        delegate.editMemo(item)
    }
}
