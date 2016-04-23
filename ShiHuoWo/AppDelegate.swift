//
//  AppDelegate.swift
//  ShiHuoWo
//
//  Created by Hesse on 16/2/16.
//  Copyright © 2016年 Hesse. All rights reserved.
//

import UIKit
import Alamofire

var AppVersion: String {
    return NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as! String
}

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        // 在这里，App已完成启动，可以做一些设置
        stylise()
        
        return true
    }

    private func stylise() {
        
        let color = WColor.greenColor()
        
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        UITabBar.appearance().tintColor = color
        
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont.systemFontOfSize(12.0), NSForegroundColorAttributeName: color], forState: .Selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont.systemFontOfSize(12.0),NSForegroundColorAttributeName: UIColor.grayColor()], forState: .Disabled)
        
    }

    
}

