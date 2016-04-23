//
//  ForgetPasswordVC.swift
//  Shenma
//
//  Created by Hesse on 16/3/10.
//  Copyright © 2016年 Hesse. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ForgetPasswordVC: UIViewController {

    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var checkCode: UITextField!
    
    @IBOutlet weak var getCheckCodeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fixNavigationBarBlackBackground()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.animateBackground(show: true)
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func getCheckCode(sender: UIButton) {
        guard let phone = phone.text where phone.isPhoneNumber else {
            showAlert(title: "请输入正确的手机号")
            return
        }
        
        showChrysanthemum(true)
        
//        Alamofire.request(.POST, DZAPI.SendSMSCheckCode, parameters: ["cellphone": phone]).responseJSON { (response: Response<AnyObject, NSError>) -> Void in
//            
//            self.showChrysanthemum(false)
//            
//            guard response.result.isSuccess else {
//                self.showNetworkDisconnectAlert()
//                return
//            }
//            
//            let json = JSON(response.result.value!)
//            print(json)
//            
//            switch json["message"].stringValue {
//            case "Success":
//                self.showAlert(title: "验证码已发送", message: "请注意查收")
//                self.timeCountingDown()
//                
//            default:
//                self.showAlert(title: "请求验证码失败")
//            }
//        }
    }
    
    @IBAction func finish(sender: UIButton) {
        guard let phone = phone.text where phone.isPhoneNumber else {
            showAlert(title: "请输入正确的手机号")
            return
        }
        guard let password = password.text where password.characters.count >= 6 else {
            showAlert(title: "密码不能少于6位")
            return
        }
        guard let confirmPassword = confirmPassword.text where password == confirmPassword else {
            showAlert(title: "两次输入的密码不一致", message: "请重新输入")
            return
        }
        guard let checkCode = checkCode.text where checkCode.characters.count == 6 else {
            showAlert(title: "请输入正确的验证码")
            return
        }

        
        
    }
    
    
    // MARK: - Check Code
    private var checkCodeTimer: NSTimer?
    private var checkCodeTimeLeft = 60 {
        didSet {
            if checkCodeTimeLeft == -1 {    // 重置
                checkCodeTimer?.invalidate()
                checkCodeTimer = nil
                checkCodeTimeLeft = 60
                getCheckCodeButton.enabled = true
            } else {    // 刷新
                getCheckCodeButton.setTitle(String(checkCodeTimeLeft) + "秒后重发", forState: .Disabled)
            }
        }
    }
    @objc private func timeCountingDown() {
        if checkCodeTimer == nil {
            checkCodeTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(ForgetPasswordVC.timeCountingDown), userInfo: nil, repeats: true)
            getCheckCodeButton.enabled = false
        }
        checkCodeTimeLeft -= 1
    }
    
    private func fixNavigationBarBlackBackground() {
        let v = UIView(frame: CGRect(x: 0, y: -64, width: view.bounds.size.width, height: 64))
        v.backgroundColor = UIColor.whiteColor()
        view.addSubview(v)
    }

    

}
