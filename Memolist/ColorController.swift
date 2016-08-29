//
//  ColorController.swift
//  To Do List
//
//  Created by 原田大樹 on 2016/05/25.
//  Copyright © 2016年 原田大樹. All rights reserved.
//

import Foundation
import UIKit


/**
 色管理クラス
 */
class ColorController {
    //Smart News Color
    /*
    class func blackColor() -> UIColor {
        return UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 1.0)
    }
    class func whiteColor() -> UIColor {
        return UIColor(red: 255 / 255.0, green: 255 / 255.0, blue: 255 / 255.0, alpha: 1.0)
    }
    
    class func grayColor() -> UIColor {
        return UIColor(red: 247 / 255.0, green: 247 / 255.0, blue: 247 / 255.0, alpha: 1.0)
    }
    
    class func blueGrayColor() -> UIColor {
        return UIColor(red: 160 / 255.0, green: 173 / 255.0, blue: 184 / 255.0, alpha: 1.0)
    }
    
    class func redColor() -> UIColor {
        return UIColor(red: 231 / 255.0, green: 76 / 255.0, blue: 60 / 255.0, alpha: 1.0)
    }
    
    class func orangeColor() -> UIColor {
        return UIColor(red: 237 / 255.0, green: 152 / 255.0, blue: 18 / 255.0, alpha: 1.0)
    }
    
    class func greenColor() -> UIColor {
        return UIColor(red: 45 / 255.0, green: 199 / 255.0, blue: 111 / 255.0, alpha: 1.0)
    }
    
    class func blueColor() -> UIColor {
        return UIColor(red: 51 / 255.0, green: 148 / 255.0, blue: 213 / 255.0, alpha: 1.0)
    }
    
    class func purpleColor() -> UIColor {
        return UIColor(red: 151 / 255.0, green: 87 / 255.0, blue: 178 / 255.0, alpha: 1.0)
    }
    */
    
    class func lightGrayColor() -> UIColor {
        return UIColor(red: 239 / 255, green: 239 / 255, blue: 244 / 255, alpha: 1.0)

    }
    
    //VOEZ Color
    class func blackColor() -> UIColor {
        return UIColor(red: 80 / 255.0, green: 86 / 255.0, blue: 93 / 255.0, alpha: 1.0)
    }
    class func whiteColor() -> UIColor {
        return UIColor(red: 255 / 255.0, green: 255 / 255.0, blue: 255 / 255.0, alpha: 1.0)
    }
    
    class func grayColor() -> UIColor {
        return UIColor(red: 247 / 255.0, green: 247 / 255.0, blue: 247 / 255.0, alpha: 1.0)
    }
    
    class func blueGrayColor() -> UIColor {
        return UIColor(red: 160 / 255.0, green: 173 / 255.0, blue: 184 / 255.0, alpha: 1.0)
    }
    
    class func redColor() -> UIColor {
        return UIColor(red: 234 / 255.0, green: 135 / 255.0, blue: 143 / 255.0, alpha: 1.0)
    }
    
    class func orangeColor() -> UIColor {
        return UIColor(red: 228 / 255.0, green: 172 / 255.0, blue: 123 / 255.0, alpha: 1.0)
    }
    
    class func greenColor() -> UIColor {
        return UIColor(red: 147 / 255.0, green: 204 / 255.0, blue: 135 / 255.0, alpha: 1.0)
    }
    
    class func blueColor() -> UIColor {
        return UIColor(red: 138 / 255.0, green: 184 / 255.0, blue: 227 / 255.0, alpha: 1.0)
    }
    
    class func purpleColor() -> UIColor {
        return UIColor(red: 156 / 255.0, green: 147 / 255.0, blue: 213 / 255.0, alpha: 1.0)
    }
    
    class var colorList: [UIColor] {
        var colorArray: [UIColor] = []
        colorArray.append(ColorController.redColor())
        colorArray.append(ColorController.orangeColor())
        colorArray.append(ColorController.greenColor())
        colorArray.append(ColorController.blueColor())
        colorArray.append(ColorController.purpleColor())
        return colorArray
    }
}













