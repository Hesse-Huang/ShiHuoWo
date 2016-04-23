//
//  WColor.swift
//  ShiHuoWo
//
//  Created by Hesse on 16/2/27.
//  Copyright © 2016年 Hesse. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

class WColor: UIColor {
    /// 主色调 - 绿色 #74C02C
    override class func greenColor() -> UIColor {
        return UIColor(rgba: "#74C02C")
    }
    class func lightGreenColor() -> UIColor {
        return UIColor(rgba: "#C9FF9C")
    }
}

