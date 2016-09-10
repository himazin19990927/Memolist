//
//  Item.swift
//  Memolist
//
//  Created by 原田大樹 on 2016/09/10.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import Foundation
import UIKit

public enum ItemType: Int {
    case None
    case Memo
    case Counter
}

class Item {
    var id: Int
    var itemType: ItemType
    
    var text: String
    var check: Bool
    
    var cellName: String {
        get {
            return "No Name"
        }
    }
    
    var height: Float {
        get {
            return 55
        }
    }
    
    init() {
        //使われていないIDを設定し保持する
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        let newId = userDefaults.integerForKey("itemId") + 1
        self.id = newId
        userDefaults.setInteger(newId, forKey: "itemId")
        
        self.itemType = .None
        
        self.text = ""
        self.check = false
    }
    
    init(id: Int) {
        self.id = id
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if userDefaults.boolForKey("Item.\(self.id).exist") {
            self.itemType = ItemType(rawValue: userDefaults.integerForKey("Item.\(self.id).itemType"))!
            self.text = userDefaults.stringForKey("Item.\(self.id).text")!
            self.check = userDefaults.boolForKey("Item.\(self.id).check")
        } else {
            self.itemType = .None
            self.text = ""
            self.check = false
        }
    }
    
    func save() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.setInteger(itemType.rawValue, forKey: "Item.\(self.id).itemType")
        userDefaults.setBool(true, forKey: "Item.\(self.id).exist")
        userDefaults.setObject(self.text, forKey: "Item.\(self.id).text")
        userDefaults.setBool(self.check, forKey: "Item.\(self.id).check")
    }
    
    func removeItem() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.removeObjectForKey("Item.\(self.id).exist")
        
        userDefaults.removeObjectForKey("Item.\(self.id).itemType")
        userDefaults.removeObjectForKey("Item.\(self.id).text")
        userDefaults.removeObjectForKey("Item.\(self.id).check")
    }
    
    func createItemCell() -> UITableViewCell {
        return UITableViewCell()
    }
}

















