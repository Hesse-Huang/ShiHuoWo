//
//  DZNavigationBar.swift
//  Shenma
//
//  Created by Hesse on 16/2/25.
//  Copyright © 2016年 Hesse. All rights reserved.
//

import UIKit

class DZNavigationBar: UINavigationBar {

    override init(frame: CGRect) {
        super.init(frame: frame)
        furtherInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        furtherInit()
    }
    
    private func furtherInit() {
        DZNavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
        DZNavigationBar.appearance().shadowImage = UIImage()
        DZNavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        titleTextAttributes = [NSFontAttributeName : UIFont.boldSystemFontOfSize(16),
                    NSForegroundColorAttributeName : UIColor.whiteColor()]
    }
    
}

