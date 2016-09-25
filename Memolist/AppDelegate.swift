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
//itemId:Itemの固有ID

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var pageArray: [Page] = []
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
//        if !userDefaults.boolForKey("firstLunch") {
//            print("初回起動")
//            
//            userDefaults.setBool(true, forKey: "firstLunch")
//            userDefaults.setInteger(0, forKey: "pageId")
//            userDefaults.setInteger(0, forKey: "memoId")
//            userDefaults.setInteger(0, forKey: "itemId")
//            initPageArray()
//        } else {
//            loadAllPage()
//        }
        initPageArray()
        
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
        let page = Page()
        page.title = "スワイプで\nリストを移動"
        page.color = ColorController.blueColor()
        
        let item1 = Memo()
        item1.color = ColorController.blueColor()
        item1.text = "このセルをタップ"
        item1.memo = "アイテムをタップすると\nセルを開閉することができます"
        page.items.append(item1)
        
        let item2 = Memo()
        item2.color = ColorController.blueColor()
        item2.text = "チェックボックスをタップ"
        item2.check = true
        page.items.append(item2)
        
        let item3 = Counter()
        item3.color = ColorController.blueColor()
        item3.text = "数字を - +  ボタンで変更"
        item3.open = true
        page.items.append(item3)
        
        let item4 = Schedule()
        item4.color = ColorController.blueColor()
        item4.text = "・・・ ボタンで内容を変更できます"
        item4.date = NSDate()
        item4.open = true
        page.items.append(item4)
        
        pageArray.append(page)
        
        let page2 = Page()
        page2.title = "リスト"
        page2.color = ColorController.redColor()
        
        let item5 = Memo()
        item5.text = "追加ボタンでアイテムの追加"
        item5.color = ColorController.redColor()
        page2.items.append(item5)
        
        let item6 = Memo()
        item6.text = "リストボタンでリストの編集"
        item6.color = ColorController.redColor()
        page2.items.append(item6)
        
        let item7 = Memo()
        item7.text = "編集ボタンでアイテムの削除"
        item7.color = ColorController.redColor()
        page2.items.append(item7)
    }
    
    func saveAllPage() {
        var pageIdArray: [Int] = []
        for page in pageArray {
            pageIdArray.append(page.id)
            page.save()
        }
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(pageIdArray, forKey: "pageIdArray")
    }
    
    func loadAllPage() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let pageIdArray: [Int] = userDefaults.objectForKey("pageIdArray") as? [Int] {
            for pageId in pageIdArray {
                
                let page = Page(pageId: pageId)
                
                pageArray.append(page)
            }
            
        } else {
            initPageArray()
        }
    }
}
