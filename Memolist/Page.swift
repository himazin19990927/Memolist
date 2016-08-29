//
//  Page.swift
//  To Do List
//
//  Created by 原田大樹 on 2016/08/22.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import Foundation
import UIKit

class Page {
    var title: String = ""
    var items: [ScheduleItem] = []
    var color: UIColor = UIColor.blackColor()
    private(set) var id: Int
    
    init() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var newId = userDefaults.integerForKey("pageId")
        newId += 1
        self.id = newId
        userDefaults.setInteger(id, forKey: "pageId")
    }
    
    init(page: Page) {
        self.title = page.title
        self.items = page.items
        self.color = page.color
        self.id = page.id
    }
    
    init(pageId: Int) {
        self.id = pageId
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if userDefaults.boolForKey("Page.\(self.id).exist") {
            self.title = userDefaults.stringForKey("Page.\(self.id).title")!
            
            //UIColorはデシリアライズする
            let colorData = userDefaults.objectForKey("Page.\(self.id).color") as! NSData
            if let color = NSKeyedUnarchiver.unarchiveObjectWithData(colorData) as? UIColor {
                self.color = color
            }
            
            //itemを初期化
            self.items.removeAll()
            if let memoIdArray: [Int] = userDefaults.objectForKey("Page.\(self.id).memoIdArray") as? [Int] {
                print("Page.\(self.id) has \(memoIdArray)")
                for itemId in memoIdArray {
                    let item = ScheduleItem(memoId: itemId)
                    self.items.append(item)
                }
            } else {
                print("Page.\(self.id) has no item")
            }
        }
    }
    
    func save() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        //必要??
        userDefaults.removeObjectForKey("Page.\(id).title")
        userDefaults.removeObjectForKey("Page.\(id).color")
        //
        
        userDefaults.setBool(true, forKey: "Page.\(id).exist")
        userDefaults.setObject(title, forKey: "Page.\(id).title")
        
        //UIColorはシリアライズする
        let colorData = NSKeyedArchiver.archivedDataWithRootObject(color)
        userDefaults.setObject(colorData, forKey: "Page.\(id).color")
        
        
        //itemを保存
        var memoIdArray: [Int] = []
        for item in items {
            memoIdArray.append(item.id)
            item.save()
        }
        print("Page.\(self.id) has \(memoIdArray)")
        userDefaults.setObject(memoIdArray, forKey: "Page.\(self.id).memoIdArray")
        
        userDefaults.synchronize()
    }
    
    func removeObject() {
        print("Page.\(id) Remove")
        //NSUserDefaultsのオブジェクトを削除する
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.removeObjectForKey("Page.\(id).exist")
        userDefaults.removeObjectForKey("Page.\(id).title")
        userDefaults.removeObjectForKey("Page.\(id).color")
        userDefaults.removeObjectForKey("Page.\(self.id).memoIdArray")
        
    }
    
}




























