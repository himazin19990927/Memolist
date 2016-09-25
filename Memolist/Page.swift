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
    var items: [Item] = []
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
            if let itemIdArray: [Int] = userDefaults.objectForKey("Page.\(self.id).itemIdArray") as? [Int] {
                for itemId in itemIdArray {
                    let itemType = ItemType(rawValue: userDefaults.integerForKey("Item.\(itemId).itemType"))!
                    //check
                    let item: Item!
                    switch itemType {
                    case .Memo:
                        item = Memo(id: itemId)
                    case .Counter:
                        item = Counter(id: itemId)
                    case .Schedule:
                        item = Schedule(id: itemId)
                    default:
                        item = Item(id: itemId)
                    }
                    self.items.append(item)
                }
            }
        }
    }
    
    func save() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.setBool(true, forKey: "Page.\(id).exist")
        userDefaults.setObject(title, forKey: "Page.\(id).title")
        
        //UIColorはシリアライズする
        let colorData = NSKeyedArchiver.archivedDataWithRootObject(color)
        userDefaults.setObject(colorData, forKey: "Page.\(id).color")
        
        //itemを保存
        var itemIdArray: [Int] = []
        for item in items {
            itemIdArray.append(item.id)
            item.save()
        }
        
        userDefaults.setObject(itemIdArray, forKey: "Page.\(self.id).itemIdArray")
        
        userDefaults.synchronize()
    }
    
    func removeObject() {
        //NSUserDefaultsのオブジェクトを削除する
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.removeObjectForKey("Page.\(id).exist")
        userDefaults.removeObjectForKey("Page.\(id).title")
        userDefaults.removeObjectForKey("Page.\(id).color")
        userDefaults.removeObjectForKey("Page.\(self.id).itemIdArray")
        
        for item in items {
            item.removeItem()
        }
        
    }
    
}




























