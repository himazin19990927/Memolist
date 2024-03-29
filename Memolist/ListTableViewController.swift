//
//  ListTableViewController.swift
//  To Do List
//
//  Created by 原田大樹 on 2016/05/28.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController, OpenCellDelegate {
    
    var cellArray: [UITableViewCell] = []
    
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
        tableView.separatorColor = ColorController.blueGrayColor()
        
        scrollEnabled()
        
        //セルの初期化
        //Check
        self.tableView.registerNib(UINib(nibName: "MemoCell", bundle: nil), forCellReuseIdentifier: "MemoCell")
        self.tableView.registerNib(UINib(nibName: "CounterCell", bundle: nil), forCellReuseIdentifier: "CounterCell")
        self.tableView.registerNib(UINib(nibName: "ScheduleCell", bundle: nil), forCellReuseIdentifier: "ScheduleCell")
        
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
        return 1
    }

    //セクションごとのセルの数を設定
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cellArray.count
    }

    //セルを設定
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return cellArray[indexPath.row]
    }
    
    //セルの高さを設定
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let item = page.items[indexPath.row]
        
        let cellHeight:CGFloat = 55
        if item.open {
            switch item.itemType {
            case .Memo:
                let memoCell = cellArray[indexPath.row] as! MemoCell
                memoCell.memoTextView.sizeToFit()
                let size = memoCell.memoTextView.contentSize
                return cellHeight + size.height
            case .Counter:
                return cellHeight + 40
            case .Schedule:
                return cellHeight + 20
            default:
                break
            }
        }
        return cellHeight
    }
    
    //セルが削除できるかどうか設定
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    //セルが削除されるときに呼ばれる
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        page.items[indexPath.row].removeItem()
        page.items.removeAtIndex(indexPath.row)
        
        cellArray.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    
    //セルが並び替えられるかどうか設定
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    //セルが移動された時に呼ばれる
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        //アイテムを移動
        let targetItem = page.items[sourceIndexPath.row]
        page.items.removeAtIndex(sourceIndexPath.row)
        page.items.insert(targetItem, atIndex: destinationIndexPath.row)
        
        //セルを更新
        initCell()
    }
    
    //セルが選択された時に呼ばれる
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.editing = editing        
    }
    
    //セルが存在しない場合スクロールを禁止する
    func scrollEnabled() {
        if cellArray.isEmpty {
            self.tableView.scrollEnabled = false
        } else {
            self.tableView.scrollEnabled = true
        }
    }
    
    private func initCell() {
        cellArray.removeAll()
        
        for item in page.items {
            let cell = createCell(item)
            cellArray.append(cell)
        }
    }
    
    func saveWidget() {
        
    }
 
    func reloadCell() {
        initCell()
        tableView.reloadData()
    }
    
    func alert(viewControllerToPresent: UIViewController) {
        self.presentViewController(viewControllerToPresent, animated: true, completion: nil)
    }
    
    func createCell(item: Item) -> UITableViewCell {
        //Check
        switch item.itemType {
        case .Memo:
            let memoCell = tableView.dequeueReusableCellWithIdentifier("MemoCell") as! MemoCell
            memoCell.item = item
            memoCell.delegate = AppController.instance.viewController
            memoCell.openCellDelegate = self
            
            return memoCell
        case .Counter:
            let counterCell = tableView.dequeueReusableCellWithIdentifier("CounterCell") as! CounterCell
            counterCell.item = item
            counterCell.delegate = AppController.instance.viewController
            counterCell.openCellDelegate = self
            return counterCell
        case .Schedule:
            let scheduleCell = tableView.dequeueReusableCellWithIdentifier("ScheduleCell") as! ScheduleCell
            scheduleCell.item = item
            scheduleCell.delegate = AppController.instance.viewController
            scheduleCell.openCellDelegate = self
            return scheduleCell
        default:
            break
        }
        
        return UITableViewCell()
    }
    
    func changeOpenCell() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func deleteCheckedItem() {
        var removeItemIndexPath: [NSIndexPath] = []
        for i in 0 ..< page.items.count {
            
            if page.items[i].check {
                removeItemIndexPath.append(NSIndexPath(forRow: i, inSection: 0))
            }
        }
        
        for i in 0 ..< removeItemIndexPath.count {
            
            print("i:\(i) removeItemIndexPath:\(removeItemIndexPath.count) items:\(page.items.count)")
            
            let index = removeItemIndexPath.count - i - 1
            let row = removeItemIndexPath[index].row
            page.items[row].removeItem()
            page.items.removeAtIndex(row)
            
            cellArray.removeAtIndex(row)
        }
        
        tableView.deleteRowsAtIndexPaths(removeItemIndexPath, withRowAnimation: .Fade)
    }
}




















