//
//  CounterController.swift
//  Memolist
//
//  Created by 原田大樹 on 2016/09/21.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import Foundation
import UIKit

class CounterController {
    static let instance = CounterController()
    
    private init() {}
    
    var counter: Counter?
    var counterBuf: Counter?
}