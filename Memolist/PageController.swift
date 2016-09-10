//
//  PageController.swift
//  Memolist
//
//  Created by 原田大樹 on 2016/09/10.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import Foundation

class PageController {
    static let instance = PageController()
    
    private init() {}
    
    var page: Page?
    var pageBuf: Page?
}