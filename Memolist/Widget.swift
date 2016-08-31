//
//  Widget.swift
//  To Do List
//
//  Created by 原田大樹 on 2016/08/17.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import Foundation

public enum WidgetType: Int {
    case None
    case Label
    case ToDo
    case Counter
}

//itemId

class Widget {
    var id: Int
    var cellName: String = ""
    var widgetType: WidgetType = .None
    var height: Float = 0
    
    init() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var newId = userDefaults.integerForKey("itemId")
        newId += 1
        self.id = newId
        userDefaults.setInteger(newId, forKey: "itemId")
    }
    
    class func removeWidget(widget: Widget) {
        //Check
        switch widget.widgetType {
        case .Label:
            let label = widget as! Label
            label.removeObject()
        case .ToDo:
            let toDo = widget as! ToDo
            toDo.removeObject()
        case .Counter:
            let counter = widget as! Counter
            counter.removeObject()
        default:
            break
        }
    }
}