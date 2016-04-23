//
//  WoCellGradientView.swift
//  ShiHuoWo
//
//  Created by Hesse on 16/3/13.
//  Copyright © 2016年 Hesse. All rights reserved.
//

import UIKit

class WoCellGradientView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        let layer = CAGradientLayer()
        let layerHeight = CGFloat(60)
        layer.frame = CGRect(x: 0, y: bounds.size.height - layerHeight, width: bounds.size.width, height: layerHeight)
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 0, y: 1)
        layer.colors = [UIColor.clearColor().CGColor, UIColor.blackColor().CGColor]
        layer.locations = [0.0, 1.0]
        self.layer.addSublayer(layer)
    }
    
}
