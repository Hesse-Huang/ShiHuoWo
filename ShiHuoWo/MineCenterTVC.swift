//
//  MineCenterTVC.swift
//  Shenma
//
//  Created by Hesse on 16/2/23.
//  Copyright © 2016年 Hesse. All rights reserved.
//

import UIKit

class MineCenterTVC: UITableViewController {
    

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userSignature: UILabel!
    @IBOutlet weak var balance: UILabel!
    @IBOutlet weak var savedMoney: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Header
        let offSetBudget = CGFloat(500)
        tableView.tableHeaderView!.frame = CGRect(x: 0, y: 0, width: 0, height: offSetBudget + 210)
        tableView.contentInset = UIEdgeInsets(top: -offSetBudget, left: 0, bottom: 0, right: 0)
        // Footer
        tableView.tableFooterView!.frame = CGRect(x: 0, y: 0, width: 0, height: 58)
        
        
        updateProfileData()
        
        NSNotificationCenter.defaultCenter().addObserverForName(WNotification.UserDidLogin.rawValue, object: nil, queue: NSOperationQueue.mainQueue()) { _ in
            self.updateProfileData()
        }
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.changeStatusBarStyle(.LightContent)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    

    @IBAction func avatarDidTap(sender: UITapGestureRecognizer) {
        User.sharedInstance.userID != nil ? changeAvatar() : showLoginVC()
    }
    
    private func updateProfileData() {
        userName.text = User.sharedInstance.name
        userSignature.text = User.sharedInstance.signature
        balance.text = User.sharedInstance.balance != nil ? "￥" + String(User.sharedInstance.balance!) : "--"
        savedMoney.text = User.sharedInstance.savedMoney != nil ? "￥" + String(User.sharedInstance.savedMoney!) : "--"
        
        if User.sharedInstance.name == "识货窝测试团队" {
            avatar.image = UIImage(named: "DemoAvatar")
        }
    }

    private func changeAvatar() {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        ac.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "更改头像", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }
    private func showLoginVC() {
        presentViewController(MainStoryBoardVC(.LoginVCNC), animated: true, completion: nil)
    }
    
    @IBAction func logout(sender: UIButton) {
        guard User.sharedInstance.userID != nil else {
            sn_errorNotice("你还没登录呢~")
            return
        }
        let ac = UIAlertController(title: "确认退出登录？", message: nil, preferredStyle: .ActionSheet)
        ac.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "退出登录", style: .Destructive, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let sid = segue.identifier {
            switch sid {
            case "SBSIDToQRCodeCardVC":
                guard User.sharedInstance.userID != nil else {
                    sn_errorNotice("你还没登录呢~")
                    return
                }
                let qrcvc = segue.destinationViewController as! QRCodeCardVC
                qrcvc.avatar = avatar.image
            default: break
            }
        }
    }
    

}
