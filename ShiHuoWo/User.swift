//
//  User.swift
//  ShiHuoWo
//
//  Created by Hesse on 16/3/3.
//  Copyright © 2016年 Hesse. All rights reserved.
//

import UIKit
import SwiftyJSON

enum UserGender: Int {
    case None, Male, Female
}
enum ItemCategory {
    case Clothes, Eletronics, Snacks
}

class User: NSObject {
    
    static var sharedInstance: User! = User()
    private override init() {
        super.init()
    }
    
    private(set) var account: Account!

    var userID: String?
    var name: String = "未登录"
    var gender: UserGender = .None
    var avatarPath: String = ""
    var signature: String = "点击头像登录"
    
    var phoneNumber: String = ""
    
    var friendsCount = 0
    
    var isSeller = false
    var sellerGrade: Double?
    var preferredCategories = [ItemCategory]()
    
    var balance: Double?
    var savedMoney: Double?
    
    
    /**
     新用户注册后调动登录
     
     */
    func loginWithUserID(userID: String, userName: String, phone: String, password: String) {
        self.userID = userID
        self.name = userName
        self.phoneNumber = phone
        
        self.userWillLogin()
    }
    /**
     用户一般正常登录时调用
     
     - parameter data:     返回的json data
     */
    func loginWithJSONInfo(info: JSON, password: String) {
        self.userID         = info["uid"].stringValue
        self.name           = info["uname"].stringValue
        self.phoneNumber    = info["cellphone"].stringValue
        self.avatarPath     = info["avatar"].stringValue
        self.signature      = info["introduce"].stringValue
        self.gender         = UserGender(rawValue: info["sex"].intValue) ?? .None
        
        self.userWillLogin()
    }
    
    private func userWillLogin() {
        postWNotification(.UserDidLogin)
    }
    
    func testLogin() {
        userID = "10086"
        name = "识货窝测试团队"
        phoneNumber = "15625100939"
        signature = "Talk is cheap, show me the code"
        gender = UserGender(rawValue: 1)!
        balance = 298.5
        savedMoney = 38.9
        userWillLogin()
    }
    
    
    
}


