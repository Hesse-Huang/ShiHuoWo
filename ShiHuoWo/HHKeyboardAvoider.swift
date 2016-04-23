//
//  HHKeyboardAvoider.swift
//  Shenma
//
//  Created by Hesse on 16/3/13.
//  Copyright © 2016年 Hesse. All rights reserved.
//

import Foundation

class HHKeyboardAvoider: NSObject {
    
    deinit {
        if observingTextFields != nil {
            NSNotificationCenter.defaultCenter().removeObserver(self)
            observingTextFields = nil
        }
    }
    
    private lazy var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HHKeyboardAvoider.tapAction(_:)))
    
    @objc private func tapAction(sender: UITapGestureRecognizer) {
        observingView?.endEditing(false)
    }
    
    /// The view to be observed. Basically the `view` property of UIViewController object.
    private(set) weak var observingView: UIView?
    
    /**
     Add a tap gesture recognizer on the view in order to make it advoid keyboard blocking.
     
     - parameter view: view that needs to advoid blocking by keyboard
     */
    func advoidViewBeingBlocked(view: UIView) {
        observingView = view
        observingView!.addGestureRecognizer(tap)
    }
    
    private(set) var observingTextFields: [UITextField]?
    private(set) weak var observingTextFieldsReferenceView: UIView?
    
    /**
     Avoid the text fields being blocked. If blocked, the text field will move up automatically.
     
     - parameter textFields: text fields (should be no more than 5) that needs to advoid blocking by keyboard
     - parameter view:       the reference view, should be the `view` property of UIViewController object.
     */
    func advoidTextFieldsBeingBlocked(textFields: [UITextField], onReferenceView view: UIView) {
        observingTextFields = textFields
        observingTextFieldsReferenceView = view
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HHKeyboardAvoider.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HHKeyboardAvoider.keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)

    }
    @objc private func keyboardWillShow(notification: NSNotification) {
        
    }
    @objc private func keyboardWillHide() {
        
    }
    

    
}

