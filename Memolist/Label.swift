//
//  Label.swift
//  Memolist
//
//  Created by 原田大樹 on 2016/08/26.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import Foundation

class Label: Widget {
    var text: String!
    var date: NSDate?
    
    override init() {
        super.init()
        super.cellName = "ラベル"
        super.widgetType = WidgetType.Label
        super.height = 55
        
        text = ""
    }
    
    convenience init(itemId: Int) {
        self.init()
        self.id = itemId
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if userDefaults.boolForKey("Item.\(self.id).exist") {
            self.date = userDefaults.objectForKey("Item.\(self.id).date") as? NSDate
            self.text = userDefaults.stringForKey("Item.\(self.id).text")
        }
    }
    
    override func save() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        //必要??
        userDefaults.removeObjectForKey("Item.\(self.id).date")
        userDefaults.removeObjectForKey("Item.\(self.id).text")
        //
        
        userDefaults.setBool(true, forKey: "Item.\(self.id).exist")
        userDefaults.setObject(date, forKey: "Item.\(self.id).date")
        userDefaults.setObject(text, forKey: "Item.\(self.id).text")
    }
    
    override func removeObject() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.removeObjectForKey("Item.\(self.id).exist")
        userDefaults.removeObjectForKey("Item.\(self.id).date")
        userDefaults.removeObjectForKey("Item.\(self.id).text")
    }
}






















