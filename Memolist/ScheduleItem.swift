//
//  ScheduleItem.swift
//  To Do List
//
//  Created by 原田大樹 on 2016/05/29.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import Foundation
import UIKit

class ScheduleItem {
    private(set) var id: Int
    var open: Bool = false
    var title: String = ""
    var color: UIColor = UIColor.blackColor()
    var widgets: [Widget] = []
    
    init() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var newId = userDefaults.integerForKey("memoId")
        newId += 1
        self.id = newId
        userDefaults.setInteger(newId, forKey: "memoId")
    }
    
    init(memo: ScheduleItem) {
        self.id = memo.id
        self.open = memo.open
        self.title = memo.title
        self.color = memo.color.copy() as! UIColor
        self.widgets = memo.widgets
    }
    
    init(memoId: Int) {
        self.id = memoId
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if userDefaults.boolForKey("Memo.\(self.id).exist") {
            self.open = userDefaults.boolForKey("Memo.\(self.id).open")
            self.title = userDefaults.stringForKey("Memo.\(self.id).title")!
            
            //UIColorはデシリアライズする
            let colorData = userDefaults.objectForKey("Memo.\(self.id).color") as! NSData
            if let color = NSKeyedUnarchiver.unarchiveObjectWithData(colorData) as? UIColor {
                self.color = color
            }
            
            //widgetを初期化
            widgets.removeAll()
            if let itemIdArray: [Int] = userDefaults.objectForKey("Memo.\(self.id).itemIdArray") as? [Int] {
                if let widgetTypeArray: [Int] = userDefaults.objectForKey("Memo.\(self.id).widgetTypeArray") as? [Int] {
                    for index in 0 ..< itemIdArray.count {
                        //widgetType
                        //Check
                        let itemTypeArray = WidgetType(rawValue: widgetTypeArray[index])!
                        switch itemTypeArray {
                        case .Label:
                            let label = Label(itemId: itemIdArray[index])
                            widgets.append(label)
                        case .ToDo:
                            let toDo = ToDo(itemId: itemIdArray[index])
                            widgets.append(toDo)
                        case .Counter:
                            let counter = Counter(itemId: itemIdArray[index])
                            widgets.append(counter)
                        default:
                            break
                        }
                    }
                }
            }
        }
    }
    
    func save() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        //必要??
        userDefaults.removeObjectForKey("Memo.\(self.id).open")
        userDefaults.removeObjectForKey("Memo.\(self.id).title")
        userDefaults.removeObjectForKey("Memo.\(self.id).color")
        userDefaults.removeObjectForKey("Memo.\(self.id).itemIdArray")
        userDefaults.removeObjectForKey("Memo.\(self.id).widgetTypeArray")
        //
        
        userDefaults.setBool(true, forKey: "Memo.\(self.id).exist")
        userDefaults.setBool(open, forKey: "Memo.\(self.id).open")
        userDefaults.setObject(title, forKey: "Memo.\(self.id).title")
        
        //UIColorはシリアライズする
        let colorData = NSKeyedArchiver.archivedDataWithRootObject(color)
        userDefaults.setObject(colorData, forKey: "Memo.\(self.id).color")
        
        //Widgetがキャストしてから保存
        var itemIdArray: [Int] = []
        var itemTypeArray: [Int] = []
        //check
        for widget in widgets {
            itemIdArray.append(widget.id)
            itemTypeArray.append(widget.widgetType.rawValue)
            //Check
            switch widget.widgetType {
            case .Label:
                let label = widget as! Label
                label.save()
            case .ToDo:
                let toDo = widget as! ToDo
                toDo.save()
            case .Counter:
                let counter = widget as! Counter
                counter.save()
            default:
                break
            }
        }
        
        userDefaults.setObject(itemIdArray, forKey: "Memo.\(self.id).itemIdArray")
        userDefaults.setObject(itemTypeArray, forKey: "Memo.\(self.id).widgetTypeArray")
        
        userDefaults.synchronize()
    }
    
    func removeObject() {
        print("Memo.\(id) Remove")
        //NSUserDefaultsのオブジェクトを削除する
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.removeObjectForKey("Memo.\(self.id).open")
        userDefaults.removeObjectForKey("Memo.\(self.id).exist")
        userDefaults.removeObjectForKey("Memo.\(self.id).title")
        userDefaults.removeObjectForKey("Memo.\(self.id).color")
        
        for widget in widgets {
            Widget.removeWidget(widget)
        }
    }
}




































