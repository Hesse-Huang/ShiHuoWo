//
//  DZCarouselView.swift
//  MySingleViewApp
//
//  Created by Hesse on 15/11/28.
//  Copyright © 2015年 Dazhua. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

protocol DZCarouseViewDelegate: class {
    func carouseView(carouseView: DZCarouselView, didTapImageAtIndex index: Int)
}


class DZCarouselView: UIView, UIScrollViewDelegate {

    private let kWidth = Screen.Width
    private let kHeight: CGFloat
    
    private var scrollView: UIScrollView!
    private(set) var pageControl: UIPageControl!
    
    weak var delegate: DZCarouseViewDelegate?
    
    var currentPage: Int {
        return pageControl.currentPage
    }

    var imageViews: [UIImageView]!
    var leftMirrorImageView: UIImageView {
        return imageViews.first!
    }
    var rightMirrorImageView: UIImageView {
        return imageViews.last!
    }
    
    private var tap: UITapGestureRecognizer?
    
    
    private(set) var repeatingInterval: NSTimeInterval = 4
    private var timer: NSTimer?
    
    
    init(height: CGFloat) {
        self.kHeight = height
        super.init(frame: CGRectMake(0, 0, kWidth, kHeight))
        
        let numberOfImages = 3
        
        scrollView = UIScrollView(frame: self.bounds)
        scrollView.contentSize = CGSizeMake(CGFloat(numberOfImages + 2) * kWidth, kHeight)
        scrollView.contentOffset = CGPointMake(kWidth, 0)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.pagingEnabled = true
        scrollView.bounces = false
        scrollView.delegate = self
        addSubview(scrollView)
        
        pageControl = UIPageControl(frame: CGRectMake(0, kHeight - 37, kWidth, 37))
        pageControl.currentPage = 0
        pageControl.numberOfPages = numberOfImages
        pageControl.pageIndicatorTintColor = UIColor.lightGrayColor()
        pageControl.currentPageIndicatorTintColor = WColor.greenColor()
        pageControl.pageIndicatorTintColor = UIColor(white: 1.0, alpha: 0.5)
        addSubview(pageControl)
        
        imageViews = [UIImageView]()
        for _ in 0 ..< numberOfImages + 2 {
            expandImageViews()
        }
        updateMirrorImageView()
        
        updateViewThatCanBeTapped()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(repeatingInterval, target: self, selector: #selector(DZCarouselView.scrollToNextPage), userInfo: nil, repeats: true)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Public functions
    
    /**
    使用此方法以更新CarouseView的图
    
    - parameter urlStrings: images的路径
    */
    func updateADImagesWithURLStrings(urlStrings: [String]) {
        for i in 0 ..< urlStrings.count {
            if i > self.imageViews.count - 3 {
                expandImageViews()
            }
            guard let url = NSURL(string: urlStrings[i]) else { continue }
            self.imageViews[i + 1].kf_setImageWithURL(url, placeholderImage: nil, optionsInfo: [.Transition(.Fade(0.25))]) { (image, error, cacheType, imageURL) -> () in
                if i == 0 || i == urlStrings.count - 1 {
                    self.updateMirrorImageView()
                }
            }
        }
    }
    
    
    // MARK: - Private Methods
    func updateMirrorImageView() {
        leftMirrorImageView.image = imageViews[imageViews.count - 2].image
        rightMirrorImageView.image = imageViews[1].image
    }
    @objc private func scrollToNextPage() {
        let rect = CGRectMake(scrollView.contentOffset.x + kWidth, 0, kWidth, kHeight)
        scrollView.scrollRectToVisible(rect, animated: true)
    }
    private func expandImageViews() {
        let newImageView = UIImageView(frame: CGRectMake(CGFloat(imageViews.count) * kWidth, 0, kWidth, kHeight))
        newImageView.contentMode = .ScaleAspectFill
        newImageView.clipsToBounds = true
        newImageView.userInteractionEnabled = true
        newImageView.tag = imageViews.count + 100
        
        imageViews.append(newImageView)
        
        pageControl.numberOfPages = imageViews.count - 2
        
        scrollView.contentSize = CGSizeMake(CGFloat(imageViews.count) * kWidth, kHeight)
        scrollView.addSubview(newImageView)
    }
    /**
     更新tap作用的View
     */
    private func updateViewThatCanBeTapped() {
        if tap == nil {
            tap = UITapGestureRecognizer(target: self, action: #selector(DZCarouselView.handleTap(_:)))
        }
        viewWithTag(pageControl.currentPage + 1 + 100)?.addGestureRecognizer(tap!)
    }
    
    // MARK: - UIScrollView Delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / kWidth - 0.5)
        pageControl.currentPage = page
        
        // 即将滚动入mirrorImageView时，update pageControl
        let position = scrollView.contentOffset.x / kWidth
        if position < 0.5 {
            pageControl.currentPage = imageViews.count - 3
        } else if position > CGFloat(imageViews.count) - 2 + 0.5 {
            pageControl.currentPage = 0
        }
        
        updateViewThatCanBeTapped()
        
        // 滚动进入到mirrorImageView时，修改contentOffset
        if position == 0.0 {
            scrollView.contentOffset = CGPointMake(CGFloat(imageViews.count - 2) * kWidth, 0)
        } else if position == CGFloat(imageViews.count - 1) {
            scrollView.contentOffset = CGPointMake(kWidth, 0)
        }
    }
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        timer?.invalidate()
        timer = nil
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if timer == nil {
            timer = NSTimer.scheduledTimerWithTimeInterval(repeatingInterval, target: self, selector: #selector(DZCarouselView.scrollToNextPage), userInfo: nil, repeats: true)
        }
    }
    
    // MARK: - Image View Tap Gestures
    @objc private func handleTap(tap: UITapGestureRecognizer) {
        delegate?.carouseView(self, didTapImageAtIndex: pageControl.currentPage + 1)
    }
    
    
    
}
