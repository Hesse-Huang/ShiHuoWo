//
//  DiscoverVC.swift
//  ShiHuoWo
//
//  Created by Hesse on 16/2/27.
//  Copyright © 2016年 Hesse. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class DiscoverVC: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var copyImageView: UIImageView!
    @IBOutlet weak var middleImageView: UIImageView!
    @IBOutlet weak var bottomImageView: UIImageView!
    @IBOutlet weak var overlaidImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton! {
        didSet {
            if let selectedColor = likeButton.layer.borderUIColor {
                likeButton.setBackgroundColor(selectedColor, forState: .Selected)
            }
        }
    }
    @IBOutlet weak var dislikeButton: UIButton! {
        didSet {
            if let selectedColor = dislikeButton.layer.borderUIColor {
                dislikeButton.setBackgroundColor(selectedColor, forState: .Selected)
            }
        }
    }
    
    private var visiableImageViews: [UIImageView] {
        return [mainImageView, middleImageView, bottomImageView, overlaidImageView]
    }
    
    
    private lazy var pan: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(DiscoverVC.drag(_:)))
    
    private let imageWidth = Screen.Width - 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        copyImageView.image = mainImageView.image
        mainImageView.addGestureRecognizer(pan)
        visiableImageViews.forEach({$0.kf_showIndicatorWhenLoading = true})

        // 解决“跳一下”问题吧。。
        likeButton.selected = true
        dislikeButton.selected = true
        
        navigationController?.backgroundHidden = true
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if pageToPrefetch == 1 {
            prefetchPictures()
        }
    }

    private var mainImageBeganCenter: CGPoint = CGPoint.zero
    private var touchPoint: CGPoint = CGPoint.zero
    
    private var heightToLike: CGFloat = 0
    private var heightToDislike: CGFloat = 0
    
    private var middleImageViewBeganCenterY: CGFloat = 0
    private var bottomImageViewBeganCenterY: CGFloat = 0
    private var bottomImageViewBeganFrame: CGRect  = CGRect.zero
    
    
    func drag(sender: UIPanGestureRecognizer) {

        switch sender.state {
        case .Began:    // 用户开始触摸屏幕时，记录相关位置数据
            mainImageBeganCenter = mainImageView.center
            touchPoint = sender.locationInView(view)
            
            heightToLike = CGRectGetMinY(mainImageView.frame) - CGRectGetMaxY(likeButton.frame)
            heightToDislike = CGRectGetMinY(dislikeButton.frame) - CGRectGetMaxY(mainImageView.frame)
            
            middleImageViewBeganCenterY = middleImageView.center.y
            bottomImageViewBeganCenterY = bottomImageView.center.y
            bottomImageViewBeganFrame   = bottomImageView.frame
            
            
        case .Changed:  // 用户正在拖曳时，随着拖曳位置的改变，缩放imageView或改变button.selected
            let deltaX = sender.locationInView(view).x - touchPoint.x
            let deltaY = sender.locationInView(view).y - touchPoint.y
            mainImageView.center.x = mainImageBeganCenter.x + deltaX
            mainImageView.center.y = mainImageBeganCenter.y + deltaY
            
            let distanceToLike = CGRectGetMinY(mainImageView.frame) - CGRectGetMaxY(likeButton.frame)
            let distanceToDislike = CGRectGetMinY(dislikeButton.frame) - CGRectGetMaxY(mainImageView.frame)
            
            likeButton.selected = distanceToLike <= 0
            dislikeButton.selected = distanceToDislike <= 0
            
            // 0 <= factor <= 1
            let factor = max(0, min((distanceToLike / heightToLike), (distanceToDislike / heightToDislike)))
            // imageViews的scaling，原来的middle大小是main的0.9倍，bottom是middle的0.9倍
            let scale = (10 - factor) / 9
            middleImageView.transform = CGAffineTransformMakeScale(scale, scale)
            bottomImageView.transform = CGAffineTransformMakeScale(scale, scale)
            // imageViews的transitioning，同上，y差为10
            let offseter = 10 * factor
            middleImageView.center.y = middleImageViewBeganCenterY - (1 - factor) * (middleImageViewBeganCenterY - view.center.y)
            bottomImageView.center.y = bottomImageViewBeganCenterY - (1 - factor) * (bottomImageViewBeganCenterY - middleImageViewBeganCenterY)
            
            
        case .Ended:    // 用户结束拖曳时，判断被拖曳的imageView应不应该滑出屏幕，执行相应的动画效果，最终回归未拖曳状态
            if likeButton.selected || dislikeButton.selected {
                
                func generateNewBottomImageView() {
                    self.mainImageView.frame = self.bottomImageViewBeganFrame
                    self.mainImageView.transform = self.bottomImageView.transform
                    UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveLinear, animations: {
                        }, completion: nil)
                }
                
                // 图片滑出的效果
                let direction: CGFloat = likeButton.selected ? -1 : 1
                var tx: CGFloat { return direction * (mainImageView.center.x - likeButton.center.x) }
                var ty: CGFloat { return direction * (mainImageView.center.y + 1000) }
                UIView.animateWithDuration(0.4, delay: 0.0, options: .CurveEaseIn, animations: {
                    self.mainImageView.transform = CGAffineTransformMakeTranslation(tx, ty)
                    }, completion: { _ in
                        self.mainImageView.transform = CGAffineTransformIdentity
                        self.mainImageView.center = self.view.center
                        
                        self.middleImageView.transform = CGAffineTransformIdentity
                        self.middleImageView.center.y = self.middleImageViewBeganCenterY
                        
                        self.bottomImageView.transform = CGAffineTransformIdentity
                        self.bottomImageView.center.y = self.bottomImageViewBeganCenterY
                        
                        self.mainImageView.image = self.middleImageView.image
                        self.middleImageView.image = self.bottomImageView.image
                        self.bottomImageView.image = self.overlaidImageView.image
                        self.loadNextPictureOnOverlaidImageView()
                        UIView.transitionWithView(self.copyImageView, duration: 0.4, options: .TransitionCrossDissolve, animations: {
                            self.copyImageView.image = self.mainImageView.image
                            }, completion: nil)
                })
                
                
            } else {
                UIView.animateWithDuration(0.6,
                    delay: 0.0,
                    usingSpringWithDamping: 0.5,
                    initialSpringVelocity: 0,
                    options: .CurveEaseInOut,
                    animations: {
                        self.mainImageView.center = self.view.center
                        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
                        
                        self.middleImageView.transform = CGAffineTransformIdentity
                        self.bottomImageView.transform = CGAffineTransformIdentity
                        
                        self.middleImageView.center.y = self.middleImageViewBeganCenterY
                        self.bottomImageView.center.y = self.bottomImageViewBeganCenterY
                        
                    }, completion: { finished in
                        self.heightToLike = 0
                        self.heightToDislike = 0
                })
            }
            
            likeButton.selected = false
            dislikeButton.selected = false
            
            
        default: break
        }
        
        

    }
    
    
    private var picPaths: [String] = [String]()
    private var pageToPrefetch: Int = 1
    private func prefetchPictures() {
        // 菊花走起
        self.showChrysanthemum(true)
        
        let parameters = [
            "page": String(pageToPrefetch),
            "size": "6"
        ]
        
        Alamofire.request(.POST, WAPI.DiscoverPics.rawValue, parameters: parameters).responseJSON { (response: Response<AnyObject, NSError>) in
            
            self.showChrysanthemum(false)
            
            guard response.result.isSuccess else {
                self.showNetworkDisconnectAlert()
                return
            }
            
            let json = JSON(response.result.value!)
            print(json)
            
//            switch json.wResult {
//            case .Succeed:
//                ()
//            default:
//                self.showAlert(title: "请求“发现”失败")
//            }

            self.picPaths = json.map({ $1["imgurl"].stringValue })
            
            ImagePrefetcher(urls: self.picPaths.flatMap({ NSURL(string: $0) }), optionsInfo: nil, progressBlock: nil, completionHandler: { (skippedResources, failedResources, completedResources) in
                self.prefetchDidFinish()
            }).start()
        }

    }
    
    /**
     预加载完成后调动此方法
     */
    private func prefetchDidFinish() {
        if pageToPrefetch == 1 {
            firstLoadPictruesOnImageViews()
        }
        pageToPrefetch += 1
    }
    /**
     界面刚显示时，第一次从预加载缓存中取出图片并加载到四个imageView上
     */
    private func firstLoadPictruesOnImageViews() {
        for i in 0 ..< visiableImageViews.count {
            guard let url = NSURL(string: picPaths.removeFirst()) else {
                showAlert(title: "某些图片无法被加载！")
                return
            }
            visiableImageViews[i].kf_setImageWithURL(url, placeholderImage: nil, optionsInfo: [KingfisherOptionsInfoItem.Transition(ImageTransition.Fade(0.3))], completionHandler: { image, _, _, _ in
                if i == 0 {
                    self.copyImageView.image = image
                }
            })
        }
    }
    /**
     使overlaidImageView加载下一张图片，如果没有图了，去请求
     */
    private func loadNextPictureOnOverlaidImageView() {
        guard let url = NSURL(string: picPaths.removeFirst()) else {
            showAlert(title: "某些图片无法被加载！")
            return
        }
        overlaidImageView.kf_setImageWithURL(url, placeholderImage: nil, optionsInfo: [.Transition(.Fade(0.3))], completionHandler: nil)
        
        if picPaths.isEmpty {
            prefetchPictures()
        }
    }
    
}









