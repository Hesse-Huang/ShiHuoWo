//
//  GoodsDetailCell.swift
//  Shenma
//
//  Created by Hesse on 16/3/16.
//  Copyright © 2016年 Hesse. All rights reserved.
//

import UIKit

protocol GoodsDetailCustomizable: class {
    func customize(item item: Item)
}

class GoodsDetailCell: UITableViewCell, GoodsDetailCustomizable, DZCarouseViewDelegate {
    
    // MARK: - BannerCell
    private lazy var carouseView: DZCarouselView = {
        let cv = DZCarouselView(height: 200)
        cv.delegate = self
        cv.pageControl.currentPageIndicatorTintColor = UIColor.whiteColor()
        cv.userInteractionEnabled = true
        self.contentView.addSubview(cv)
        return cv
    }()
    
    private lazy var scrollImages = [
        UIImage(named: "DogClothesPics1"),
        UIImage(named: "DogClothesPics2"),
        UIImage(named: "DogClothesPics3")
    ]
    private func setupBannerCell(item item: Item) {
        for i in 0 ..< scrollImages.count {
            carouseView.imageViews[i + 1].image = scrollImages[i]
        }
        carouseView.updateMirrorImageView()
    }

    
    // MARK: - DZCarouseView Delegate
    func carouseView(carouseView: DZCarouselView, didTapImageAtIndex index: Int) {
        
    }
    
    // MARK: - DetailCell1
    @IBOutlet weak var goodsName: UILabel!
    @IBOutlet weak var currentPrice: UILabel!
    @IBOutlet weak var discountBubble: UIImageView!
    @IBOutlet weak var soldAmount: UILabel!
    @IBOutlet weak var takingCondition: UILabel!
    
    private func setupDetailCell(item item: Item) {
        discountBubble.image = SHWStyleKit.imageOfBubble(content: "好友链: 8.5折优惠")
    
    }
    
    // MARK: - ShopCell
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var shopIcon: UIImageView!
    private func setupShopCell(item item: Item) {

    }
    
    
    
    // MRAK: - LongImageCell
    @IBOutlet weak var longImageView: UIImageView!
    private lazy var longImage = UIImage(named: "DogClothesLongPic")!
    
    private func setupLongCell(item item: Item) {
        longImageView.frame.size.height = longImage.size.height
        longImageView.image = longImage
    }

    
    func customize(item item: Item) {
        guard let identifier = reuseIdentifier else { return }
        switch identifier {
        case "BannerCell":
            setupBannerCell(item: item)
        case "DetailCell":
            setupDetailCell(item: item)
        case "ShopCell":
            setupShopCell(item: item)
        case "LongImageCell":
            setupLongCell(item: item)
        default:    return
        }
    }
    
}

// 此代码段并非最终的具体实现
func drag(sender: UIPanGestureRecognizer) {
    switch sender.state {
    case .Began:   ()  // 用户开始触摸屏幕时，记录相关位置数据。
    case .Changed: ()  // 用户正在拖曳时，随着拖曳位置的改变，缩放imageView或改变button.selected。
    case .Ended:   ()  // 用户结束拖曳时，判断被拖曳的imageView应不应该滑出屏幕，执行相应的动画效果，最终回归未拖曳状态。
    default: break
    }
}

