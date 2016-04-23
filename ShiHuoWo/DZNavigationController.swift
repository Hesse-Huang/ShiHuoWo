//
//  DZNavigationController.swift
//  Shenma
//
//  Created by Hesse on 16/3/14.
//  Copyright © 2016年 Hesse. All rights reserved.
//

import UIKit

public enum DZNavigationControllerStyle: Int {
    /// White background, orange titles
    case White = 0
    /// Orange backgrouond, white titles
    case AppColor = 1
}


class DZNavigationController: UINavigationController {
    
    @IBInspectable
    var type: Int = 0 {
        didSet {
            if let style = DZNavigationControllerStyle(rawValue: type) {
                self.style = style
                self.setAppearance()
            }
        }
    }
    
    private var style = DZNavigationControllerStyle.White
    
    
    var statusBarStyle = UIStatusBarStyle.LightContent {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return statusBarStyle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 去掉navigationBar下面的一条线
        navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationBar.shadowImage = UIImage()
        navigationBar.translucent = false
    }
    
    private func setAppearance() {
        var titleColor: UIColor
        var backgroundColor: UIColor
        switch style {
        case .White:
            titleColor = WColor.greenColor()
            backgroundColor = UIColor.whiteColor()
        case .AppColor:
            titleColor = UIColor.whiteColor()
            backgroundColor = WColor.greenColor()
        }
        
        navigationBar.tintColor = titleColor
        navigationBar.barTintColor = backgroundColor
        navigationBar.titleTextAttributes = [
            NSFontAttributeName : UIFont.boldSystemFontOfSize(16),
            NSForegroundColorAttributeName : titleColor]
        
    }
}

extension UIViewController {
    func changeStatusBarStyle(style: UIStatusBarStyle) {
        guard let navc = navigationController as? DZNavigationController else { return }
        navc.statusBarStyle = style
    }
}

