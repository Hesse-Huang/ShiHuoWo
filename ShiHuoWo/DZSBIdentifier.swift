//
//  DZStoryboardIdentifiers.swift
//  Shenma
//
//  Created by Hesse on 15/11/26.
//  Copyright © 2015年 Hesse. All rights reserved.
//

import UIKit

enum DZSBIdentifier: String {
    /// 登录
    case LoginVC = "SBIDLoginVC"
    /// 完善个人资料
    case CompletePersonalDetailVC = "SBIDCompletePersonalDetail"
    /// 第一次打开APP的引导页
    case GuidanceVC = "SBIDGuidanceVC"
    /// 主界面的TabBarController
    case MainTabBarVC = "SBIDMainTabBarController"
    /// 打开红包后的VC
    case RedPacketDetailVC = "SBIDRedPacketDetailVC"
    /// 商品细节
    case GoodsDetailVC = "SBIDGoodsDetailVC"
    /// 提现ViewController
    case WithdrawTVC = "SBIDWithdrawTVC"
    /// 我的提现账号
    case MyWithdrawAccountVC = "SBIDMyWithdrawAccountVC"
    /// Tab5主界面
    case MineVC = "SBIDMineVC"
    /// 条款与协议
    case ProvisionVC = "SBIDProvisionVC"
    /// 消息中心
    case MessageCenterVC = "SBIDMessageCenterVC"
    
    case TestVC = "test"
    
    /// 完善个人信息
    case FinishPersonalDetailVC = "SBIDFinishPersonalDetailVC"
    // 申请返积分
    case ApplyForScoreVC = "SBIDApplyForScoreVC"
    /// 个人信息
    case ProfileVC = "SBIDProfileVC"
    /// 摇一摇
    case ShakeVC = "SBIDShakeVC"
    /// 登录的NavigationController
    case LoginVCNC = "SBIDLoginVCNC"
}

func MainStoryBoardVC(identifier: DZSBIdentifier) -> UIViewController {
    return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(identifier.rawValue)}
