//
//  AppDelegate.swift
//  To Do List
//
//  Created by 原田大樹 on 2016/05/22.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import UIKit

@UIApplicationMain

//pageId:pageの固有ID
//memoId:scheduleItemの固有ID
//itemId:widgetの固有ID
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var pageArray: [Page] = []
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if !userDefaults.boolForKey("firstLunch") {
            print("初回起動")
            userDefaults.setBool(true, forKey: "firstLunch")
            userDefaults.setInteger(0, forKey: "pageId")
            userDefaults.setInteger(0, forKey: "memoId")
            userDefaults.setInteger(0, forKey: "itemId")
            initPageArray()
        } else {
            loadAllPage()
        }
        
        //戻るボタンの色を変更
        UINavigationBar.appearance().tintColor = ColorController.blackColor()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        saveAllPage()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    private func initPageArray() {
        pageArray.removeAll()
        let page1 = Page()
        page1.title = "リスト1"
        page1.color = ColorController.blueColor()
        
        let memo1 = ScheduleItem()
        memo1.color = ColorController.blueColor()
        memo1.title = "メモは編集ボタンから消去"
        page1.items.append(memo1)
        
        let memo2 = ScheduleItem()
        memo2.color = ColorController.greenColor()
        memo2.title = "ここをタップしてください"
        memo2.open = true
        
        let label1 = Label()
        label1.text = "プラスボタンからアイテムを追加"
        memo2.widgets.append(label1)
        let toDo1 = ToDo()
        toDo1.text = "設定ボタンからメモを編集"
        memo2.widgets.append(toDo1)
        let counter1 = Counter()
        memo2.widgets.append(counter1)
        page1.items.append(memo2)
        
        pageArray.append(page1)
        
        let page2 = Page()
        page2.title = "リスト2"
        page2.color = ColorController.greenColor()
        
        let memo3 = ScheduleItem()
        memo3.title = "左のボタンからリストを編集"
        memo3.color = ColorController.greenColor()
        page2.items.append(memo3)
        
        let memo4 = ScheduleItem()
        memo4.title = "右のボタンからメモを追加"
        memo4.color = ColorController.redColor()
        page2.items.append(memo4)
        pageArray.append(page2)
    }
    
    func saveAllPage() {
        var pageIdArray: [Int] = []
        for page in pageArray {
            pageIdArray.append(page.id)
            page.save()
        }
        print("(save)PageIdArray:\(pageIdArray)")
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(pageIdArray, forKey: "pageIdArray")
    }
    
    func loadAllPage() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let pageIdArray: [Int] = userDefaults.objectForKey("pageIdArray") as? [Int] {
            print("(load)\(pageIdArray)")
            for pageId in pageIdArray {
                
                let page = Page(pageId: pageId)
                
                pageArray.append(page)
            }
            
        } else {
            initPageArray()
        }
    }
}







































