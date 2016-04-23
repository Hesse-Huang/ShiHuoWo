//
//  DZPagingView.swift
//  MySingleViewApp
//
//  Created by Hesse on 15/11/27.
//  Copyright © 2015年 Dazhua. All rights reserved.
//

import UIKit

protocol DZPagingViewDelegate: class {
    func pagingView(pagingview: DZPagingView, didClickButtonAtIndex index: Int)
}

class DZPagingView: UIView {
    
    private let kButtonHeight: CGFloat = 35
    private var kButtonWidth: CGFloat = 70 {
        didSet {
            // 更新buttons
            let buttonY = buttons.first?.frame.origin.y ?? 0.0
            let height = indicatorHidden ? kButtonHeight : kButtonHeight - kIndicatorHight
            for (i, button) in buttons.enumerate() {
                button.frame = CGRectMake(kButtonWidth * CGFloat(i), buttonY, kButtonWidth, height)
            }
            // 更新indicators
            indicatorView.frame.size.width = kIndicatorWidth
            indicatorView.center.x = kIndicatorStartPointX

        }
    }
    
    private(set) var buttons = [UIButton]()
    var titles = [String]()
    
    
    var currentIndex = 0 {
        didSet {
            if currentIndex != oldValue {
                buttons[oldValue].selected = false
                buttons[currentIndex].selected = true
                indicatorScrollToIndex(currentIndex)
            }
        }
    }
    
    var indicatorHidden: Bool {
        get {
            return indicatorView.hidden
        }
        set {
            indicatorView.hidden = newValue

            let height = newValue ? kButtonHeight : kButtonHeight - kIndicatorHight
            buttons.forEach({
                $0.frame.size.height = height
            })
        }
    }
    
    
    
    // 底下的横线
    private(set) var indicatorView: UIView!
    
    private var kIndicatorWidth: CGFloat { return kButtonWidth * 0.618 }
    private let kIndicatorHight: CGFloat = 3.0
    private var kIndicatorStepWidth: CGFloat { return kButtonWidth }
    private var kIndicatorStartPointX: CGFloat { return buttons.first?.center.x ?? 0.0 }
    
    weak var delegate: DZPagingViewDelegate?
    
    convenience init(titles: [String]) {
        self.init(frame: CGRect(x: 0, y: 0, width: 70 * CGFloat(titles.count), height: 35))
        self.titles = titles
        self.setupButtons()
        self.setupIndicator()
    }
    private func setupButtons() {
        for i in 0 ..< titles.count {
            let b = UIButton(type: .System)
            b.frame = CGRectMake(kButtonWidth * CGFloat(i), 0, kButtonWidth, kButtonHeight - kIndicatorHight)
            b.setTitle(titles[i], forState: .Normal)
            b.titleLabel?.font = UIFont.boldSystemFontOfSize(17)
            b.setTitleColor(UIColor.whiteColor(), forState: .Selected)
            b.setTitleColor(WColor.lightGreenColor(), forState: .Normal)
            b.tintColor = UIColor.clearColor()
            b.backgroundColor = UIColor.clearColor()
            b.addTarget(self, action: #selector(DZPagingView.handleButton(_:)), forControlEvents: .TouchUpInside)
            self.addSubview(b)
            buttons.append(b)
        }
        buttons.first!.selected = true
    }
    private func setupIndicator() {
        indicatorView = UIView()
        indicatorView.frame = CGRectMake(0, self.kButtonHeight - self.kIndicatorHight, self.kIndicatorWidth, self.kIndicatorHight)
        indicatorView.backgroundColor = UIColor.whiteColor()
        indicatorView.center.x = self.kIndicatorStartPointX
        indicatorView.layer.cornerRadius = self.kIndicatorHight / 2
        self.addSubview(indicatorView)
    }
    /**
     使indicatorView产生位移
     */
    func indicatorScrollToIndex(index: Int) {
        let toPointX = CGFloat(index) * kIndicatorStepWidth + kIndicatorStartPointX
        UIView.animateWithDuration(0.15) {
            self.indicatorView.center.x = toPointX
        }
        
    }

    // MARK: - Private Methods
    @objc private func handleButton(sender: UIButton) {
        // 更新selected的Button
        currentIndex = buttons.indexOf({ $0 == sender })!
        
        delegate?.pagingView(self, didClickButtonAtIndex: currentIndex)
    }
    
    
    // MARK: - Customizing Buttons
    /**
     设定Buttons的颜色
     */
    func setButtonsTitleColor(color: UIColor?, forState state: UIControlState) {
        buttons.forEach({ $0.setTitleColor(color, forState: state) })
    }
    /**
     设定Buttons的字体
     */
    func setButtonFont(font: UIFont) {
        buttons.forEach({ $0.titleLabel?.font = font })
    }
    /**
     设定Buttons的宽度（实际就是设定kViewWidth）
     */
    func setButtonWidth(width: CGFloat) {
        self.kButtonWidth = width
    }
    
    
}
