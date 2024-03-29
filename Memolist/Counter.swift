//
//  Counter.swift
//  Memolist
//
//  Created by 原田大樹 on 2016/09/17.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import Foundation
import UIKit

class Counter: Item {
    var count: Int
    
    override var cellName: String {
        get {
            return "カウンター"
        }
    }
    
//    override var height: Float {
//        get {
//            return 55
//        }
//    }
    
    override init() {
        self.count = 0
        
        super.init()
        
        self.itemType = .Counter
    }
    
    init(counter: Counter) {
        count = 0
        
        super.init()
        
        id = counter.id
        itemType = counter.itemType
        text = counter.text
        check = counter.check
        color = counter.color
        open = counter.open
        
        count = counter.count
    }
    
    override init(id: Int) {
        self.count = 0
        
        super.init(id: id)
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if userDefaults.boolForKey("Item.\(self.id).exist") {
            self.count = userDefaults.integerForKey("Item.\(self.id).count")
        }
    }
    
    override func save() {
        super.save()
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setInteger(count, forKey: "Item.\(self.id).count")
        
        userDefaults.synchronize()
    }
    
    override func removeItem() {
        super.removeItem()
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.removeObjectForKey("Item.\(self.id).count")
    }
}
