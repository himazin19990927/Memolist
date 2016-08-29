//
//  ViewController.swift
//  To Do List
//
//  Created by 原田大樹 on 2016/05/22.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import UIKit
class ViewController: UIViewController, ListTableViewDelegate {
    var pageMenu: CAPSPageMenu?
    var controllerArray: [UIViewController] = []
    
    var leftBarButton: UIBarButtonItem!
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
        //self.navigationController?.navigationBar.tintColor = UIColor.blueColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: ColorController.blackColor()]
        
        //NavigationBarのボタンの設定
        let backButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
        
        navigationItem.leftBarButtonItem = editButtonItem()
        
        addBarButton = UIBarButtonItem(image: UIImage(named: "Add"), style: .Done, target: self, action: #selector(ViewController.addButtonClicked(_:)))
        listBarButton = UIBarButtonItem(image: UIImage(named: "List"), style: .Done, target: self, action: #selector(ViewController.listButtonClicked(_:)))
        
        self.navigationItem.setRightBarButtonItems([addBarButton, listBarButton], animated: true)
        
        //PageMenuの初期化
        initPageMenu()
        
        ItemController.instance.viewController = self
                
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
    
    
    //Addボタンが押された時呼ばれる
    func addButtonClicked(sender: AnyObject) {
        //データの保存
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.saveAllPage()
        
        //ウィジェットの中身を保存
        for view in controllerArray {
            let viewController = view as! ListTableViewController
            viewController.saveWidget()
        }
        
        ItemController.instance.listTableView = controllerArray[(pageMenu?.currentPageIndex)!] as? ListTableViewController
        ItemController.instance.scheduleItem = ScheduleItem()
        ItemController.instance.string = ""
        ItemController.instance.color = ItemController.instance.listTableView?.page.color
        performSegueWithIdentifier("MoveToEditor", sender: nil)
    }
    
    //Listボタンが押された時呼ばれる
    func listButtonClicked(sender: AnyObject) {
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
            viewController.delegate = self
            controllerArray.append(viewController)
            
            colorArray.append(page.color)
        }
        //CAPSPageMenuの設定
        let parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(ColorController.whiteColor()),
            .ViewBackgroundColor(ColorController.grayColor()),
            .SelectionIndicatorColor(ColorController.orangeColor()),
            .BottomMenuHairlineColor(ColorController.blueGrayColor()),
            .MenuItemFont(UIFont(name: "HelveticaNeue", size: 13.0)!),
            .MenuHeight(40.0),
            .MenuItemWidth(90.0),
            .CenterMenuItems(true),
            ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters, pageColorOptions: colorArray)
        
        self.addChildViewController(pageMenu!)
        self.view.addSubview(pageMenu!.view)
        pageMenu?.didMoveToParentViewController(self)
        
    }
    
    func editWidget(widgetType: WidgetType) {
        //データの保存
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.saveAllPage()
        
        //Check
        switch widgetType {
        case .Label:
            performSegueWithIdentifier("MoveToLabelEditor", sender: nil)
        case .Counter:
            break
        default:
            break
        }
    }
    
    func editMemo(memo: ScheduleItem) {
        //データの保存
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.saveAllPage()
        
        //ウィジェットの中身を保存
        for view in controllerArray {
            let viewController = view as! ListTableViewController
            viewController.saveWidget()
        }
        
        ItemController.instance.listTableView = controllerArray[(pageMenu?.currentPageIndex)!] as? ListTableViewController
        ItemController.instance.scheduleItem = ScheduleItem(memo: memo)
        ItemController.instance.memo = memo
        ItemController.instance.string = memo.title
        ItemController.instance.color = memo.color.copy() as? UIColor
        performSegueWithIdentifier("MoveToMemoEditor", sender: nil)
    }
}













