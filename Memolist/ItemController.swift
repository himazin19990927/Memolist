//
//  ItemController.swift
//  Memolist
//
//  Created by 原田大樹 on 2016/09/20.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import Foundation
import UIKit

class ItemController {
    static let instance = ItemController()
    
    private init() {}
    
    var page: Page?
    
    var color: UIColor?
    var itemType: ItemType?
}