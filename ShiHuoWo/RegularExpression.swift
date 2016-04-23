//
//  RegularExpression.swift
//  Shenma
//
//  Created by Hesse on 15/11/5.
//  Copyright © 2015年 Hesse. All rights reserved.
//

import Foundation

extension String {
    /// 验证手机号
    var isPhoneNumber: Bool {
        /**
         * 手机号码
         * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
         * 联通：130,131,132,152,155,156,185,186
         * 电信：133,1349,153,180,189,177
         */
         //        let mobile = "^1(3[0-9]|5[0-35-9]|77|8[0125-9])\\d{8}$"
         
         /**
         * 中国移动：China Mobile
         * 移动号段有134,135,136,137, 138,139,147,150,151,152,157,158,159,178,182,183,184,187,188
         */
        let chinaMobile = "^1(34[0-8]|(3[5-9]|5[0127-9]|78|8[23478])\\d)\\d{7}$"
        
        /**
         * 中国联通：China Unicom
         * 联通号段有130，131，132，155，156，185，186，145，176
         */
        let chinaUnicom = "^1(3[0-2]|45|5[256]|76|8[56])\\d{8}$"
        
        /**
         * 中国电信：China Telecom
         * 电信号段有133，153，177，180，181，189, 1349
         */
        let chinaTelecom = "^1((33|53|77|8[019])[0-9]|349)\\d{7}$"
        
        //        let regextestMobile: NSPredicate = NSPredicate(format: "SELF MATCHES %@", mobile)
        let regextestCM = NSPredicate(format: "SELF MATCHES %@", chinaMobile)
        let regextestCU = NSPredicate(format: "SELF MATCHES %@", chinaUnicom)
        let regextestCT = NSPredicate(format: "SELF MATCHES %@", chinaTelecom)
        return (/*regextestMobile.evaluateWithObject(mobileNum) || */regextestCM.evaluateWithObject(self) || regextestCU.evaluateWithObject(self) || regextestCT.evaluateWithObject(self))
    }
    
    /// 验证邮箱
    var isEmail: Bool {
        let emailRegax = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegax)
        return emailTest.evaluateWithObject(self)
    }
    /// 验证身份证
    var isIDCardNumber: Bool {
        let regex2 = "^(\\d{14}|\\d{17})(\\d|[xX])$"
        let identityCardPredicate = NSPredicate(format: "SELF MATCHES %@", regex2)
        return identityCardPredicate.evaluateWithObject(self)
    }
    /// 银行卡
    var isBankCardNumber: Bool {
        let regex2 = "^(\\d{15,30})"
        let bankCardPredicate = NSPredicate(format: "SELF MATCHES %@", regex2)
        return bankCardPredicate.evaluateWithObject(self)
    }
    /// 全是数字
    var areNumbers: Bool {
        let allnumRegex = "^[0-9]*$"
        let numPredicate = NSPredicate(format: "SELF MATCHES %@", allnumRegex)
        return numPredicate.evaluateWithObject(self)
    }
    /// 提现金额的验证
    var isCashbackAmount: Bool {
        let regex = "^[0-9]+(.[0-9]{1,2})?$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluateWithObject(self)
    }



}




