//
//  Counter.swift
//  To Do List
//
//  Created by 原田大樹 on 2016/08/17.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import Foundation

class Counter_old: Widget {
    var count: Int = 0
    
    override init() {
        super.init()
        super.cellName = "カウンター"
        super.widgetType = WidgetType.Counter
        super.height = 55
        
    }
    
    convenience init(itemId: Int) {
        self.init()
        self.id = itemId
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if userDefaults.boolForKey("Item.\(self.id).exist") {
            self.count = userDefaults.integerForKey("Item.\(self.id).count")
        }
    }
    
    override func save() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        //必要??
        userDefaults.removeObjectForKey("Item.\(self.id).count")
        //
        
        userDefaults.setBool(true, forKey: "Item.\(self.id).exist")
        userDefaults.setObject(count, forKey: "Item.\(self.id).count")
    }
    
    override func removeObject() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.removeObjectForKey("Item.\(self.id).exist")
        userDefaults.removeObjectForKey("Item.\(self.id).count")
    }
}