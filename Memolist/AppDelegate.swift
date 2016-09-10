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
        
        let memo1 = Memo()
        memo1.text = "hoge"
        page1.items.append(memo1)
        pageArray.append(page1)
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







































