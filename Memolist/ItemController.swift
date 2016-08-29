//
//  ItemController.swift
//  To Do List
//
//  Created by 原田大樹 on 2016/08/19.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import Foundation
import UIKit

class ItemController {
    static let instance = ItemController()
    
    private init() {}
    
    var listTableView: ListTableViewController?
    var viewController: ViewController?
    var page: Page?
    
    var memo: ScheduleItem?
    var scheduleItem: ScheduleItem?
    var deleteList: [Widget] = []
    
    var string: String?
    var color: UIColor?
    
    var item: Widget?
}