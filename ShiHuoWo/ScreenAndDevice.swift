//
//  ScreenAndDevice.swift
//  Shenma
//
//  Created by Hesse on 15/11/15.
//  Copyright © 2015年 Hesse. All rights reserved.
//

import UIKit

struct Screen {
    static let Width = UIScreen.mainScreen().bounds.width
    static let Height = UIScreen.mainScreen().bounds.height
}

enum Device {
    case iPhone4s
    case iPhone5s
    case iPhone6s
    case iPhone6sPlus
    case Others
}

var CurrentDevice: Device {
    switch Screen.Height {
    case 480.0: return .iPhone4s
    case 568.0: return .iPhone5s
    case 667.0: return .iPhone6s
    case 736.0: return .iPhone6sPlus
    default:    return .Others
    }
}
