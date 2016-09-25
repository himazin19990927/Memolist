//
//  ScheduleController.swift
//  Memolist
//
//  Created by 原田大樹 on 2016/09/25.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import Foundation
import UIKit

class ScheduleController {
    static let instance = ScheduleController()
    
    private init() {}
    
    var schedule: Schedule?
    var scheduleBuf: Schedule?
}