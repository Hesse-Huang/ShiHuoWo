//
//  FinishPersonalDetailVC.swift
//  Shenma
//
//  Created by Hesse on 15/11/11.
//  Copyright © 2015年 Hesse. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol FinishPersonalDetailVCDelegate: class {
    func finishPersonalDetailVCDidCompleteFillingDetails(finishPersonalDetailVC: FinishPersonalDetailVC)
}

class FinishPersonalDetailVC: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    deinit {
        NSLog("FinishPersonalDetailVC deinits")
    }
    

    private var gender: UserGender = .None {
        didSet {
            let selected = UIImage(named: "rb_selected")
            let unselected = UIImage(named: "rb_unselected")
            switch gender {
            case .Male:
                maleConfirmCircle.image = selected
                femaleConfirmCircle.image = unselected
            case .Female:
                maleConfirmCircle.image = unselected
                femaleConfirmCircle.image = selected
            default: break
            }
        }
    }
    @IBOutlet weak var nickname: UITextField!
    @IBOutlet weak var birthday: UITextField!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var blackView: UIView!
    
    @IBOutlet weak var maleModule: UIView!
    @IBOutlet weak var maleConfirmCircle: UIImageView!
    @IBOutlet weak var femaleModule: UIView!
    @IBOutlet weak var femaleConfirmCircle: UIImageView!
    @IBOutlet var tapOnMale: UITapGestureRecognizer!
    @IBOutlet var tapOnFemale: UITapGestureRecognizer!
    @IBOutlet var tapOnVCsView: UITapGestureRecognizer!
    
    private var keyboardIsShowing = false
    
    private let pickerHeight = CGFloat(216.0)
    private var pickerIsShowing = false {
        didSet {
            animatePicker(pickerIsShowing)
            if oldValue && !pickerIsShowing {
                applyDateOfPickerToBirthdayTextField()
            }
        }
    }
    private lazy var picker: UIDatePicker = {
        let p = UIDatePicker(frame: CGRect(x: 0, y: Screen.Height, width: Screen.Width, height: self.pickerHeight))
        p.datePickerMode = .Date
        p.backgroundColor = UIColor.whiteColor()
        return p
    }()
    
    @IBOutlet weak var finishButton: UIButton!
    
    @IBAction func tapOnMaleAction(sender: UITapGestureRecognizer) {
        gender = .Male
    }
    @IBAction func tapOnFemaleAction(sender: UITapGestureRecognizer) {
        gender = .Female
    }
    
    weak var delegate: FinishPersonalDetailVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FinishPersonalDetailVC.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FinishPersonalDetailVC.keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)

    }
    
    func appearOnView(view: UIView){
        self.view.alpha = 0
        mainView.transform = CGAffineTransformMakeScale(0.6, 0.6)
        view.addSubview(self.view)
        UIView.animateWithDuration(0.15, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
                self.view.alpha = 1
                self.mainView.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
    func disappearOnSuperview() {
        UIView.animateWithDuration(0.15, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.view.alpha = 0
            self.mainView.transform = CGAffineTransformMakeScale(0.6, 0.6)
            }, completion: { _ in
                self.view.removeFromSuperview()
                self.delegate?.finishPersonalDetailVCDidCompleteFillingDetails(self)
        })
    }
    
    @IBAction func skip(sender: AnyObject) {
        showAlert(title: "跳过填写", message: "以后可在“个人中心”中补全资料", cancelHandler: { _ in
            self.disappearOnSuperview()
        })
    }
    
    @IBAction func tapToHideKeyboard(sender: UITapGestureRecognizer) {
        if pickerIsShowing { pickerIsShowing = false }
        view.endEditing(false)
    }
    
    @IBAction func finish(sender: UIButton) {
        
        // 完成填写后，界面消失
        self.disappearOnSuperview()
        
//        // 秀菊花
//        self.showChrysanthemum(true)
//    
//        let nickname = self.nickname.text ?? ""
//        let sex = String(gender.rawValue)
//        let parameters = [
//            "uname":    nickname,
//            "sex":      sex
//        ]
        
//        Alamofire.request(.POST, DZAPI.SaveUserInfo, parameters: parameters).responseJSON { (response: Response<AnyObject, NSError>) -> Void in
//            // 停菊花
//            self.showChrysanthemum(false)
//            
//            guard response.result.isSuccess else {
//                self.showNetworkDisconnectAlert()
//                return
//            }
//            
//            let json = JSON(response.result.value!)
//            let message = DZServerMessage(rawValue: json["message"].stringValue) ?? .UnknownMessage
//            print(json)
//            
//            switch message {
//            case .Success:
//                User.sharedInstance.name = (nickname == "" ? User.sharedInstance.phoneNumber : nickname)
//                User.sharedInstance.gender = self.gender
//                
//                // 完成填写后，界面消失
//                self.disappearOnSuperview()
//                
//            default:
//                break
//            }
//        }
    }
    
    // MARK: - UITextField Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == nickname {
            nickname.resignFirstResponder()
            textFieldShouldBeginEditing(birthday)
        } else if textField == birthday {
            finish(finishButton)
        }
        return true
    }
    
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == birthday {
            if !pickerIsShowing {
                pickerIsShowing = true
            }
            return false
        }
        return true
    }
    
    private func animatePicker(show: Bool) {
        if show {
            view.addSubview(picker)
            let distanceToPicker = (Screen.Height - pickerHeight) - CGRectGetMaxY(birthday.convertRect(birthday.frame, toView: view))
            if distanceToPicker < 0 {
                UIView.animateWithDuration(0.25, delay: 0.0, options: .CurveEaseOut,
                    animations: {
                        self.mainView.transform = CGAffineTransformMakeTranslation(0, distanceToPicker - 20)
                        self.picker.frame.origin.y -= self.pickerHeight
                    }, completion: nil)
            }
        } else {
            UIView.animateWithDuration(0.25, delay: 0.0, options: .CurveEaseOut,
                animations: {
                    self.mainView.transform = CGAffineTransformIdentity
                    self.picker.frame.origin.y += self.pickerHeight
                }, completion: { _ in
                    self.picker.removeFromSuperview()
            })
        }
    }
    
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        
        keyboardIsShowing = true
        
        let info = notification.userInfo!
        let keyboardFrame = info[UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        
        guard nickname.isFirstResponder() else { return }
        let distanceToKeyboard = keyboardFrame.origin.y - CGRectGetMaxY(nickname.convertRect(nickname.frame, toView: view))
        
        if distanceToKeyboard < 20 {
            self.mainView.transform = CGAffineTransformMakeTranslation(0, distanceToKeyboard - 20)
        }
    }
    @objc private func keyboardWillHide() {
        keyboardIsShowing = false
        self.mainView.transform = CGAffineTransformIdentity
    }
    
    // MARK: - UIGesture Recognizer Delegate
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        guard gestureRecognizer != tapOnVCsView else { return true }
        if pickerIsShowing || keyboardIsShowing { return false }
        return true
    }
    
    private func applyDateOfPickerToBirthdayTextField() {
        let fmt = NSDateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        birthday.text = fmt.stringFromDate(picker.date)
    }
}
