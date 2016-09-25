//
//  Schedule.swift
//  schedulelist
//
//  Created by 原田大樹 on 2016/09/25.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import Foundation
import UIKit

class Schedule: Item {
    var date: NSDate?
    
    override var cellName: String {
        get {
            return "予定"
        }
    }
    
//    override var height: Float {
//        get {
//            return 55
//        }
//    }
    
    override init() {
        super.init()
        
        itemType = .Schedule
    }
    
    override init(id: Int) {
        super.init(id: id)
        
        itemType = .Schedule
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if userDefaults.boolForKey("Item.\(self.id).exist") {
            self.date = userDefaults.objectForKey("Item.\(self.id).date") as? NSDate
        }
    }
    
    init(schedule: Schedule) {
        super.init()
        
        self.date = schedule.date
        
        self.id = schedule.id
        self.itemType = schedule.itemType
        self.text = schedule.text
        self.check = schedule.check
        self.color = schedule.color
        self.open = schedule.open
    }
    
    override func save() {
        super.save()
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let date = self.date {
            userDefaults.setObject(date, forKey: "Item.\(self.id).date")
        } else {
            userDefaults.removeObjectForKey("Item.\(self.id).date")
        }
        
        userDefaults.synchronize()
    }
    
    override func removeItem() {
        super.removeItem()
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.removeObjectForKey("Item.\(self.id).date")
        
        userDefaults.synchronize()
    }
}



















