//
//  WNotification.swift
//  ShiHuoWo
//
//  Created by Hesse on 16/4/6.
//  Copyright © 2016年 Hesse. All rights reserved.
//

import Foundation

func postWNotification(notification: WNotification, userInfo: [NSObject: AnyObject]? = nil) {
    NSNotificationCenter.defaultCenter().postNotificationName(notification.rawValue, object: nil, userInfo: userInfo)
}

enum WNotification: String {
    case UserDidLogin
    case UserDidLogout
}