//
//  Memo.swift
//  Memolist
//
//  Created by 原田大樹 on 2016/09/10.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import Foundation
import UIKit

class Memo: Item {
    var memo: String
    
    override var cellName: String {
        get {
            return "メモ"
        }
    }
    
//    override var height: Float {
//        get {
//            return 55
//        }
//    }
    
    override init() {
        memo = ""
        
        super.init()
        
        itemType = .Memo
    }
    
    override init(id: Int) {
        memo = ""
        
        super.init(id: id)
        
        itemType = .Memo
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if userDefaults.boolForKey("Item.\(self.id).exist") {
            self.memo = userDefaults.stringForKey("Item.\(self.id).memo")!
        }
    }
    
    init(memo: Memo) {
        self.memo = ""
        
        super.init()
        
        self.memo = memo.memo
        self.id = memo.id
        self.itemType = memo.itemType
        self.text = memo.text
        self.check = memo.check
        self.color = memo.color
        self.open = memo.open
    }
    
    override func save() {
        super.save()
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(self.memo, forKey: "Item.\(self.id).memo")
    }
    
    override func removeItem() {
        super.removeItem()
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.removeObjectForKey("Item.\(self.id).memo")
    }
}















