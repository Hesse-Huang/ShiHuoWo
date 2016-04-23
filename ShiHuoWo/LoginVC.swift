//
//  LoginVC.swift
//  Shenma
//
//  Created by Hesse on 15/10/20.
//  Copyright © 2015年 Hesse. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import JDAnimationKit


class LoginVC: UIViewController, UITextFieldDelegate, FinishPersonalDetailVCDelegate {
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    @IBOutlet weak var logo: UIImageView!
    
    deinit {
        removeObserver(self, forKeyPath: "view.frame")
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSLog("LoginViewController deinits")
    }
    
    @IBOutlet weak var dismissButton: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var loginModule: UIButton!
    @IBOutlet weak var registerModule: UIButton!
    @IBOutlet weak var moduleTriangle: UIImageView!
    @IBOutlet weak var checkCodeBase: UIView!
    
    @IBOutlet weak var phone: UITextField!
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var checkCode: UITextField!
    @IBOutlet weak var forgetPasscodeButton: UIButton!
    private var textFields: [UITextField] {
        return [phone, password, checkCode]
    }
    
    @IBOutlet weak var wechatLoginButton: UIButton!
    
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var getCheckCodeButton: UIButton!
    @IBOutlet weak var protocolButton: UIButton!
    
    private lazy var finishPersonalDetailVC: FinishPersonalDetailVC = {
        let finishPersonalDetailVC = MainStoryBoardVC(.FinishPersonalDetailVC) as! FinishPersonalDetailVC
        finishPersonalDetailVC.delegate = self
        self.addChildViewController(finishPersonalDetailVC)
        return finishPersonalDetailVC
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "登录/注册", style: .Plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_close_white"), style: .Plain, target: self, action: #selector(LoginVC.dismiss))
        
        moduleTriangle.image = SHWStyleKit.imageOfLoginTriangle
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginVC.hideKeyboard)))
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginVC.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginVC.keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
        
        addObserver(self, forKeyPath: "view.frame", options: .New, context: nil)
        
        phone.text = "15625100939"
        password.text = "qwerty"
        
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.animateBackground(show: false)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationController?.navigationBar.tintColor = WColor.greenColor()
    }
    
    
    @IBAction func moduleButtonAction(sender: UIButton) {
        if sender == loginModule {
            loginModule.enabled = false
            registerModule.enabled = true
            password.frame.size.width += -61
            mainButton.setTitle("登录", forState: .Normal)
            
            moduleTriangle.moveXTo(loginModule.center.x)
            checkCodeBase.opacityTo(0.0).moveYBy(-68)
            forgetPasscodeButton.hidden = false
            protocolButton.opacityTo(0.0).moveYBy(-50)
            mainButton.setTitle("登录", forState: .Normal)
            wechatLoginButton.opacityTo(1.0).moveYBy(-50)

        } else if sender == registerModule {
            loginModule.enabled = true
            registerModule.enabled = false
            password.frame.size.width += 61
            
            moduleTriangle.moveXTo(registerModule.center.x)
            checkCodeBase.opacityTo(1.0).moveYBy(68)
            forgetPasscodeButton.hidden = true
            protocolButton.opacityTo(1.0).moveYBy(50)
            mainButton.setTitle("立即注册", forState: .Normal)
            wechatLoginButton.opacityTo(0.0).moveYBy(50)
        }
    }
    
    @IBAction func mainButtonAction(sender: UIButton) {
        !loginModule.enabled ? login() : register()
    }
    
    private func containerViewMoveUp(up: Bool) {
        UIView.animateWithDuration(0.25) {
            self.containerView.frame.origin.y += up ? -300 : 300
        }
    }

    
    
    
    // MARK: - Private Methods
    @IBAction func dismiss() {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    

    
    
    // MARK: - Login
    /**
    登录方法
    */
    private func login() {
        guard let phone = phone.text where phone.isPhoneNumber else {
            showAlert(title: "请输入正确的手机号")
            return
        }
        guard let password = password.text where password.characters.count >= 6 else {
            showAlert(title: "密码不能少于6位")
            return
        }
        
        showChrysanthemum(true)
        
        let parameters = ["phonenumber": phone, "password": password]

        
        Alamofire.request(.POST, WAPI.Login.rawValue, parameters: parameters).responseJSON { (response: Response<AnyObject, NSError>) -> Void in
            self.showChrysanthemum(false)
            guard response.result.isSuccess else {
                self.showNetworkDisconnectAlert()
                print(response.debugDescription)
                return
            }
            
            let json = JSON(response.result.value!)
            print(json)
            
//            // 根据"message"处理
//            switch message {
//            case .Success:  // 登录成功
//                User.sharedInstance.loginWithJSONData(data, password: self.password.text!)
//                self.dismiss()
//                
//            case .NotHaveThisUser:  // 账号或密码有误
//                self.showAlert(title: "用户不存在或密码错误")
//            default: break
//            }
            
            
            // 根据 wResult处理
            switch json.wResult {
            case .Succeed:
                User.sharedInstance.testLogin()
                self.showAlert(title: "登录成功") { _ in
                    self.dismiss()
                }
            case .NotExist:
                self.showAlert(title: "用户不存在或密码错误")
            default:
                self.showAlert(title: "登录失败")
            }
        }
    }
    @IBAction func loginWithWeChat(sender: AnyObject) {
        self.sn_infoNotice("敬请期待！")
    }

    
    // MARK: - Register
    /**
     注册方法
     */
    private func register() {
        guard let phone = phone.text where phone.characters.count == 11 else {
            showAlert(title: "请输入正确的手机号")
            return
        }
        guard let password = password.text where password.characters.count >= 6 else {
            showAlert(title: "密码不能少于6位")
            return
        }
        guard let checkCode = checkCode.text where checkCode.characters.count == 6 else {
            showAlert(title: "请输入正确的验证码")
            return
        }
        
        showChrysanthemum(true)
        let parameters = ["phonenumber": phone, "password": password]
        
        Alamofire.request(.POST, WAPI.Register.rawValue, parameters: parameters).responseJSON { (response: Response<AnyObject, NSError>) -> Void in
            
            self.showChrysanthemum(false)
            
            guard response.result.isSuccess else {
                self.showNetworkDisconnectAlert()
                print(response.debugDescription)
                return
            }
            
            let json = JSON(response.result.value!)
            print(json)
            
            switch json.wResult {
            case .Succeed:
//                guard let userID = data["uid"].string else { break }
//                User.sharedInstance.loginWithUserID(userID,
//                    userName: phone,
//                    phone: phone,
//                    password: password)
                self.didFinishRegister()
                
            case .Existed:
                self.showAlert(title: "用户已存在")
            default:
                break
            }
            
        
        }
    }
    private func didFinishRegister() {
        finishPersonalDetailVC.appearOnView(self.view)
    }
    
    
    // MARK: - Check Code
    @IBAction func getCheckCode(sender: AnyObject) {
        
        guard let phone = phone.text where phone.characters.count == 11 else {
            showAlert(title: "请输入正确的手机号", cancelHandler: { _ in
                self.phone.becomeFirstResponder()
            })
            return
        }

        self.showAlert(title: "验证码已发送", message: "请注意查收")
        self.timeCountingDown()
    }
    

 
    
    
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
            checkCodeTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(LoginVC.timeCountingDown), userInfo: nil, repeats: true)
            getCheckCodeButton.enabled = false
        }
        checkCodeTimeLeft -= 1
    }


    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case self.phone:
            password.becomeFirstResponder()
        case password:
            if !registerModule.enabled {    // 在注册时
                checkCode.becomeFirstResponder()
            } else {    // 在登录时
                password.resignFirstResponder()
                mainButtonAction(mainButton)
            }
        case checkCode:
            checkCode.resignFirstResponder()
        default: break
        }
        return true
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame = info[UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        
        guard let responderTextField = textFields.filter({ $0.isFirstResponder() }).first else { return }
        let distanceToKeyboard = keyboardFrame.origin.y - CGRectGetMaxY(responderTextField.convertRect(responderTextField.frame, toView: view))
        
        if distanceToKeyboard < 0 {
            view.frame.origin.y -= -distanceToKeyboard
        }
    }
    @objc private func keyboardWillHide() {
        view.frame.origin.y = 0
    }
    
    // MARK: - FinishedPersonalDetailVCDelegate
    func finishPersonalDetailVCDidCompleteFillingDetails(finishPersonalDetailVC: FinishPersonalDetailVC) {
        moduleButtonAction(loginModule)
        NSTimer.schedule(delay: 0.3) { _ in
            self.login()
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


