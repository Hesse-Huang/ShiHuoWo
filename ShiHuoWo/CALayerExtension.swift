//
//  CALayerExtension.swift
//  ShiHuoWo
//
//  Created by Hesse on 16/2/29.
//  Copyright © 2016年 Hesse. All rights reserved.
//

import UIKit

extension CALayer {
    var borderUIColor: UIColor? {
        set {
            self.borderColor = newValue?.CGColor
        }
        get {
            return borderColor != nil ? UIColor(CGColor: borderColor!) : nil
        }
    }
}
