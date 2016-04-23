//
//  WoliVC.swift
//  ShiHuoWo
//
//  Created by Hesse on 16/2/27.
//  Copyright © 2016年 Hesse. All rights reserved.
//

import UIKit

class WoliVC: UIViewController, DZPagingViewDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // MARK: - Properties
    private var pagingView = DZPagingView(titles: ["师兄窝", "师姐窝"])
    private let pageVC = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    private let sxWoVC = WoVC() // 师兄窝
    private let sjWoVC = WoVC() // 师姐窝
    
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "窝里"
        
        sxWoVC.index = 0
        sjWoVC.index = 1
        
        pagingView.delegate = self
        navigationItem.titleView = pagingView
                
        
        pageVC.view.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height)
        pageVC.delegate = self
        pageVC.dataSource = self
        pageVC.setViewControllers([sxWoVC], direction: .Forward, animated: false, completion: nil)
        
        addChildViewController(pageVC)
        view.addSubview(pageVC.view)
        
    }
    
    /**
     返回另一个ViewController
     
     - parameter viewController: 福利券VC或返现券VC，不能是其它！！
     
     - returns: 另一个VC
     */
    private func anotherWoVCForWoVC(viewController: UIViewController) -> WoVC {
        if viewController == self.sxWoVC {
            return self.sjWoVC
        } else {
            return self.sxWoVC
        }
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        return viewController == sxWoVC ? nil : sxWoVC
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        return viewController == sjWoVC ? nil : sjWoVC
    }
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else { return }
        let pvc = previousViewControllers.first!
        let avc = anotherWoVCForWoVC(pvc)
        pagingView.currentIndex = avc.index
    }
    
    
    // MARK: - DZPagingViewDelegate
    func pagingView(pagingview: DZPagingView, didClickButtonAtIndex index: Int) {
        var vcs: [UIViewController]!
        var direction: UIPageViewControllerNavigationDirection!
        switch index {
        case 0:
            vcs = [sxWoVC]
            direction = .Reverse
        case 1:
            vcs = [sjWoVC]
            direction = .Forward
        default:
            return
        }
        pageVC.setViewControllers(vcs, direction: direction, animated: true, completion: nil)
    }

    






}
