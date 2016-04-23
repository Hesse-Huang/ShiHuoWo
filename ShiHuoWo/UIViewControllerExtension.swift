//
//  UIViewControllerExtension.swift
//  ShiHuoWo
//
//  Created by Hesse on 16/4/6.
//  Copyright © 2016年 Hesse. All rights reserved.
//

import UIKit


extension UIViewController {
    public func showChrysanthemum(show: Bool) {
        if show {
            self.sn_pleaseWait()
            view.userInteractionEnabled = false
        } else {
            self.sn_clearAllNotice()
            view.userInteractionEnabled = true
        }
    }
}