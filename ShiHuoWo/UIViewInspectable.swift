//
//  UIViewInspectable.swift
//  ShiHuoWo
//
//  Created by Hesse on 16/4/6.
//  Copyright © 2016年 Hesse. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable var layerCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    @IBInspectable var layerBorderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    @IBInspectable var layerBorderColor: UIColor? {
        get {
            return layer.borderColor == nil ? nil : UIColor(CGColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.CGColor
        }
    }
}
