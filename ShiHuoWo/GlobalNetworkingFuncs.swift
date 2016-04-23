//
//  GlobalNetworkingFuncs.swift
//  Shenma
//
//  Created by Hesse on 15/10/28.
//  Copyright © 2015年 Hesse. All rights reserved.
//

import UIKit
import SwiftyJSON

/// hideCondition: 满足时，此UIAlertAction不显示
public typealias AlertOption = (title: String, action: ((UIAlertAction) -> Void)?)

extension UIViewController {
    
    /*======================================== 请求失败 ========================================*/
    public func showNetworkDisconnectAlert(completion: (() -> Void)? = nil) {
        let ac = UIAlertController(title: "请求失败", message: "请检查网络，或稍候再尝试", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "确定", style: .Cancel, handler: nil))
        presentViewController(ac, animated: true, completion: completion)
    }

    /*==================================== 自己封装的AlertView ================================*/
    
    public func showNoActionAlert(title title: String?, message: String? = nil, showDuration: NSTimeInterval, dismissCompletion: (() -> Void)? = nil) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        presentViewController(ac, animated: true, completion: nil)
        NSTimer.schedule(delay: showDuration) { _ in
            self.dismissViewControllerAnimated(true) {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    /**

    - parameter cancelTitle:   默认为"我知道了"
    - parameter cancelHandler: 默认为nil
    */
    public func showAlert(title title: String?, message: String? = nil, cancelTitle: String = "我知道了", cancelHandler: ((UIAlertAction) -> Void)? = nil) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: cancelTitle, style: .Cancel, handler: cancelHandler))
        presentViewController(ac, animated: true, completion: nil)
    }
    /**
     
     - parameter cancelTitle:   默认为"我知道了"
     - parameter cancelHandler: 默认为nil
     */
    public func showTwoActionsAlert(title title: String?, message: String? = nil, cancelTitle: String = "我知道了", cancelHandler: ((UIAlertAction) -> Void)? = nil, confirmTitle: String, confirmHandler: ((UIAlertAction) -> Void)) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: cancelTitle, style: .Cancel, handler: cancelHandler))
        ac.addAction(UIAlertAction(title: confirmTitle, style: .Default, handler: confirmHandler))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    /**
    请求用户登录用的Alert
    */
    public func showNeedLogin(title title: String = "请先登录", message: String) {
        self.showTwoActionsAlert(
            title: title,
            message: message,
            confirmTitle: "现在登录", confirmHandler: { _ in
                self.presentViewController(MainStoryBoardVC(DZSBIdentifier.LoginVC), animated: true, completion: nil)
        })
    }
    
     /**
     条件显示的Alert
     
     - parameter title:         Alert的title
     - parameter message:       Alert的message
     - parameter hideCondition: true时，此Alert不出现
     - parameter cancelOption:  true时，有"取消"的UIAlertAction
     - parameter options:       要添加的UIAlertAction
     */
    public func showOptionalShowingAlert(title: String, message: String?, hideCondition: Bool, cancelOption: Bool = true, options: [AlertOption]) {
        guard !hideCondition else { return }
        let ac = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        if cancelOption {
            ac.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
        }
        for option in options {
            ac.addAction(UIAlertAction(title: option.title, style: .Default, handler: option.action))
        }
        presentViewController(ac, animated: true, completion: nil)
    }
    
    /*==================================== Debug用的AlertView ==================================*/
    public func showAlertWithJSON(json: JSON, cancelHandler: ((UIAlertAction) -> Void)? = nil) {
        let ac = UIAlertController(title: "message: \(json["message"])\ncode: \(json["code"])", message: "data: \(json["data"])", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "确定", style: .Cancel, handler: cancelHandler))
        presentViewController(ac, animated: true, completion: nil)
        
    }
    public func showErrorAlertWithJSON(json: JSON) {
        let ac = UIAlertController(title: "操作失败", message: "message: \(json["message"])\ncode: \(json["code"])", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "确定", style: .Cancel, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    
    
    

    
}

