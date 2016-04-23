//
//  UINavigationControllerExtension.swift
//  ShiHuoWo
//
//  Created by Hesse on 16/4/6.
//  Copyright © 2016年 Hesse. All rights reserved.
//

import UIKit

extension UINavigationController {
    var background: UIView {
        return navigationBar.subviews[0]
    }
    var backgroundHidden: Bool {
        get {
            return background.hidden
        }
        set {
            background.hidden = newValue
        }
    }
    func animateBackground(show show: Bool) {
        UIView.animateWithDuration(0.15) {
            self.background.alpha = show ? 1.0 : 0.0
        }
    }
}
