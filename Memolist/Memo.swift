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
    override var cellName: String {
        get {
            return "メモ"
        }
    }
    
    override var height: Float {
        get {
            return 55
        }
    }
    
    override init() {
        super.init()
        
        itemType = .Memo
    }
    
    override init(id: Int) {
        super.init(id: id)
    }
    
    override func save() {
        super.save()
    }
    
    override func removeItem() {
        super.removeItem()
    }
}















