//
//  GoodsDetailVC.swift
//  Shenma
//
//  Created by Hesse on 15/10/29.
//  Copyright © 2015年 Hesse. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON

class GoodsDetailVC: UITableViewController {
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    deinit {
        removeObserver(self, forKeyPath: "view.frame")
    }
    
        
    // 底下的位置不变的两个Buttons
    private let buttomButtonViewHeight = CGFloat(49.0)
    // 或一个Button
    @IBOutlet var bottomSingleButtonView: UIView!
    @IBOutlet var bottomGoPurchaseButton: UIButton!

    
    
    private lazy var longImage = UIImage(named: "DogClothesLongPic")!
    
    var item: Item!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: buttomButtonViewHeight, right: 0)
        
        // 添加底下的Button(s)
        setupBottomButtonsView()
        
        self.addObserver(self, forKeyPath: "view.frame", options: .New, context: nil)
        

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.animateBackground(show: false)
        
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.animateBackground(show: true)
    }
    
    private func setupBottomButtonsView() {
        bottomSingleButtonView.frame = CGRect(x: 0, y: Screen.Height - buttomButtonViewHeight, width: Screen.Width, height: buttomButtonViewHeight)
        view.addSubview(bottomSingleButtonView)
    }

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        // 保持bottomButtonsView置底
        let position = offsetY + Screen.Height - buttomButtonViewHeight
        bottomSingleButtonView.frame.origin.y = position
        // 令NavigaitonBar变化
        let alphaPercentage = min(max(0, offsetY), 200) / 200
        navigationController?.background.alpha = alphaPercentage
    }
    
    
    // MARK: - Bottom Buttons Action
    @IBAction func goPurchase(sender: UIButton) {
        print("Go Purchase!")
        
    }


    
    // MARK: - UITableView Data Source & Delegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return 200
        case 1: return 162
        case 2: return 40
        case 3: return Screen.Width / longImage.size.width * longImage.size.height
        default: return 0
        }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var identifier: String {
            switch indexPath.row {
            case 0: return "BannerCell"
            case 1: return "DetailCell"
            case 2: return "ShopCell"
            case 3: return "LongImageCell"
            default: return ""
            }
        }
        return tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
    }
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = cell as? GoodsDetailCell {
            self.item = Item()
            cell.customize(item: item)
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "view.frame" {
            if let value = change?[NSKeyValueChangeNewKey] {
                let rect = value.CGRectValue()
                if rect.origin.y == 64.0 {
                    view.frame = CGRect(x: 0, y: 0, width: Screen.Width, height: Screen.Height)
                }
            }
        }
    }
    
    

}
