//
//  WoVC.swift
//  ShiHuoWo
//
//  Created by Hesse on 16/2/27.
//  Copyright © 2016年 Hesse. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

typealias WoGoodsLike = (Bool, Int)

class WoVC: UITableViewController, WoCellLikeDelegate {
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    private let woCellIdentifier = "WoCellIdentifier"
    
    /// 师兄窝的VC为0，师姐窝为1
    var index = 0
    
    private var titles = [String]()
    private var picPaths = [String]()
    private var likes = [WoGoodsLike]()
    
    private var pageToPrefetch = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .None
        
        tableView.registerNib(UINib(nibName: "WoCell", bundle: nil), forCellReuseIdentifier: woCellIdentifier)
        
        addRefreshControl()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if pageToPrefetch == 1 {
            prefetchPictures()
        }
    }
    
    private func addRefreshControl() {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(WoVC.refreshData), forControlEvents: .ValueChanged)
        rc.attributedTitle = NSAttributedString(string: "正在加载...")
        refreshControl = rc
    }
    
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
            
            self.picPaths.appendContentsOf(json.map({ $1["imgurl"].stringValue }))
            self.titles.appendContentsOf(json.map({ $1["productlabel"].stringValue }))
            
            ImagePrefetcher(urls: self.picPaths.flatMap({ NSURL(string: $0) }), optionsInfo: nil, progressBlock: nil, completionHandler: { (skippedResources, failedResources, completedResources) in
                self.prefetchDidFinish()
            }).start()
        }
    }
    private func prefetchDidFinish() {
        tableView.reloadData()
        pageToPrefetch += 1
        if loadingMore {
            loadingMore = false
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = self.picPaths.count
        let likesCount = likes.count
        if rows > likesCount {
            likes.appendContentsOf(Array(count: rows - likesCount, repeatedValue: (false, 16)))
        }
        return rows
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(woCellIdentifier, forIndexPath: indexPath)
    }
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = cell as? WoCell {
            if cell.delegate == nil {
                cell.delegate = self
            }
            let row = indexPath.row
            cell.customizeWithImageURLString(picPaths[row], title: titles[row], like: likes[row], row: row)
        }
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 260
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dvc = MainStoryBoardVC(DZSBIdentifier.GoodsDetailVC)
        navigationController?.pushViewController(dvc, animated: true)
    }
    
    @objc private func refreshData() {
        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(WoVC.endRefreshing), userInfo: nil, repeats: false)
    }
    @objc private func endRefreshing() {
        refreshControl?.endRefreshing()
    }
    
    // MARK: - Auto Load More
    /// 如已经发出网络请求但未返回，为true
    private var loadingMore = false
    /// 当没有更多数据时，为false
    private var mayLoadAgain = true
    override func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        guard !picPaths.isEmpty else { return }
        let reachBottom = (scrollView.bounds.size.height + targetContentOffset.memory.y >= scrollView.contentSize.height - 1)

        if mayLoadAgain && !loadingMore && reachBottom {
            loadingMore = true
            prefetchPictures()
        }
    }
    
    // MARK: - WoCellLikeDataSource
    func woCell(woCell: WoCell, didTapLike like: Bool) {
        guard let row = woCell.row else { return }
        likes[row].0 = like
        likes[row].1 += like ? 1 : -1
    }

    
}
