//
//  ToDo.swift
//  Memolist
//
//  Created by 原田大樹 on 2016/08/26.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import Foundation

class ToDo: Widget {
    var text: String!
    var date: NSDate?
    var check: Bool!
    
    override init() {
        super.init()
        super.cellName = "チェックボックス"
        super.widgetType = WidgetType.ToDo
        super.height = 55
        
        text = ""
        check = false
    }
    
    convenience init(itemId: Int) {
        self.init()
        self.id = itemId
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if userDefaults.boolForKey("Item.\(self.id).exist") {
            self.date = userDefaults.objectForKey("Item.\(self.id).date") as? NSDate
            self.text = userDefaults.stringForKey("Item.\(self.id).text")
            self.check = userDefaults.boolForKey("Item.\(self.id).check")
        }
    }
    
    func save() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        //必要??
        userDefaults.removeObjectForKey("Item.\(self.id).date")
        userDefaults.removeObjectForKey("Item.\(self.id).text")
        userDefaults.removeObjectForKey("Item.\(self.id).check")
        //
        
        userDefaults.setBool(true, forKey: "Item.\(self.id).exist")
        userDefaults.setObject(date, forKey: "Item.\(self.id).date")
        userDefaults.setObject(text, forKey: "Item.\(self.id).text")
        userDefaults.setObject(check, forKey: "Item.\(self.id).check")
    }
    
    func removeObject() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.removeObjectForKey("Item.\(self.id).exist")
        userDefaults.removeObjectForKey("Item.\(self.id).date")
        userDefaults.removeObjectForKey("Item.\(self.id).text")
        userDefaults.removeObjectForKey("Item.\(self.id).check")
    }
}






















