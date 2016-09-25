//
//  ViewController.swift
//  To Do List
//
//  Created by 原田大樹 on 2016/05/22.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import UIKit
class ViewController: UIViewController, ItemEditorDelegate {
    var pageMenu: CAPSPageMenu?
    var controllerArray: [UIViewController] = []
    
    var configBarButton: UIBarButtonItem!
    var addBarButton: UIBarButtonItem!
    var listBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //NavigationBarの設定
        self.title = "Memolist"
        self.navigationController?.navigationBar.barTintColor = ColorController.whiteColor()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Default
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: ColorController.blackColor()]
        
        //NavigationBarのボタンの設定
        let backButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        navigationItem.backBarButtonItem = backButtonItem
        
        configBarButton = UIBarButtonItem(image: UIImage(named: "Edit"), style: .Done, target: self, action: #selector(ViewController.configButton(_:)))
        navigationItem.leftBarButtonItems = [editButtonItem(), configBarButton]
        navigationItem.leftBarButtonItem = editButtonItem()
        
        
        addBarButton = UIBarButtonItem(image: UIImage(named: "Add"), style: .Done, target: self, action: #selector(ViewController.addButton(_:)))
        
        listBarButton = UIBarButtonItem(image: UIImage(named: "List"), style: .Done, target: self, action: #selector(ViewController.listButton(_:)))
        
        self.navigationItem.setRightBarButtonItems([addBarButton, listBarButton], animated: true)
        
        //PageMenuの初期化
        initPageMenu()
        
        AppController.instance.viewController = self
                
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        //データの保存
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.saveAllPage()
        
        pageMenu?.reloadData()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func shouldAutomaticallyForwardAppearanceMethods() -> Bool {
        return true
    }
    
    override func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return true
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        addBarButton.enabled = !editing
        listBarButton.enabled = !editing
        for view in controllerArray {
            let viewController = view as! ListTableViewController
            
            viewController.setEditing(editing, animated: animated)
            
        }
        
    }
    
    //Configボタンが押されたときに呼ばれる
    func configButton(sender :AnyObject) {
        let configAlert = UIAlertController(title: "その他", message: nil, preferredStyle: .ActionSheet)
        
        let deleteCheckedItem = UIAlertAction(title: "チェック済みを削除", style: .Default, handler: { action in
            let alert = UIAlertController(title: "チェック済みのアイテムを\n消しますか", message: nil, preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: { action in
                let listTableViewController = self.controllerArray[(self.pageMenu?.currentPageIndex)!] as! ListTableViewController
                listTableViewController.deleteCheckedItem()
            })
            alert.addAction(okAction)
            
            let cancelAction = UIAlertAction(title: "キャンセル", style: .Cancel, handler: nil)
            alert.addAction(cancelAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
        })
        configAlert.addAction(deleteCheckedItem)
        
        let cancel = UIAlertAction(title: "キャンセル", style: .Cancel, handler: {
            (action: UIAlertAction) in
            print("cancel")
        })
        configAlert.addAction(cancel)
        
        self.presentViewController(configAlert, animated: true, completion: nil)
        
    }
    
    //Addボタンが押された時に呼ばれる
    func addButton(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let page = appDelegate.pageArray[(pageMenu?.currentPageIndex)!]
        
        ItemController.instance.page = page
        ItemController.instance.color = page.color
        ItemController.instance.itemType = ItemType.Memo
        
        performSegueWithIdentifier("MoveToItemCreator", sender: nil)
    }
    
    //Listボタンが押された時に呼ばれる
    func listButton(sender: AnyObject) {
        //データの保存
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.saveAllPage()
        
        //ウィジェット中身を保存
        for view in controllerArray {
            let viewController = view as! ListTableViewController
            viewController.saveWidget()
        }
        
        performSegueWithIdentifier("MoveToAllPageEditor", sender: nil)
    }
    
    //PageMenuを初期化する
    func initPageMenu() {
        //現在表示されているpageMenuを消去
        if pageMenu != nil {
            pageMenu?.removeFromParentViewController()
            pageMenu = nil
            controllerArray.removeAll()
        }
        //controllerArrayの設定
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let pageArray = appDelegate.pageArray
        
        var colorArray: [UIColor] = []
        
        for page in pageArray {
            let viewController = ListTableViewController()
            
            viewController.page = page
            controllerArray.append(viewController)
            
            colorArray.append(page.color)
        }
        
        //CAPSPageMenuの設定
        let parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(ColorController.whiteColor()),
            .ViewBackgroundColor(ColorController.grayColor()),
            .SelectionIndicatorColor(ColorController.orangeColor()),
            .BottomMenuHairlineColor(ColorController.blueGrayColor()),
            .MenuItemFont(UIFont(name: "HelveticaNeue", size: 12.0)!),
            .MenuHeight(40.0),
            .MenuItemWidth(90.0),
            .CenterMenuItems(true),
            ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters, pageColorOptions: colorArray)
        
        pageMenu?.controllerScrollView.backgroundColor = UIColor.whiteColor()
        
        self.addChildViewController(pageMenu!)
        
        self.view.addSubview(pageMenu!.view)
        pageMenu?.didMoveToParentViewController(self)
        
    }
    
    func editItem(item: Item) {
        switch item.itemType {
        case .Memo:
            let memoController = MemoController.instance
            let memo = item as! Memo
            
            memoController.memo = memo
            memoController.memoBuf = Memo(memo: memo)
            
            performSegueWithIdentifier("MoveToMemoEditor", sender: nil)
        case .Counter:
            let counterController = CounterController.instance
            let counter = item as! Counter
            
            counterController.counter = counter
            counterController.counterBuf = Counter(counter: counter)
            
            performSegueWithIdentifier("MoveToCounterEditor", sender: nil)
        case .Schedule:
            let scheduleController = ScheduleController.instance
            let schedule = item as! Schedule
            
            scheduleController.schedule = schedule
            scheduleController.scheduleBuf = Schedule(schedule: schedule)
            performSegueWithIdentifier("MoveToScheduleEditor", sender: nil)
        default:
            break
        }
    }
}













