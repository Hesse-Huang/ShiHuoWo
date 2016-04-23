//
//  IBInspectableExtensions.swift
//  Shenma
//
//  Created by Hesse on 16/3/17.
//  Copyright © 2016年 Hesse. All rights reserved.
//

import UIKit

extension UIButton {
    
    @IBInspectable var normalStateBackgroundColor: UIColor? {
        // not gettable
        get { return nil }
        set {
            if let color = newValue {
                setBackgroundColor(color, forState: .Normal)
            }
        }
    }
    @IBInspectable var disabledStateBackgroundColor: UIColor? {
        // not gettable
        get { return nil }
        set {
            if let color = newValue {
                setBackgroundColor(color, forState: .Disabled)
            }
        }
    }
    @IBInspectable var highlightedStateBackgroundColor: UIColor? {
        // not gettable
        get { return nil }
        set {
            if let color = newValue {
                setBackgroundColor(color, forState: .Highlighted)
            }
        }
    }
    
    func setBackgroundColor(color: UIColor, forState state: UIControlState) {
        
        var image : UIImage {
            UIGraphicsBeginImageContext(bounds.size)
            
            let context = UIGraphicsGetCurrentContext()
            CGContextSetFillColorWithColor(context, color.CGColor)
            CGContextFillRect(context, bounds)
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return image
        }
        
        setBackgroundImage(image, forState: state)
    }

    
}
