//
//  WAPI.swift
//  Shenma
//
//  Created by Hesse on 15/10/26.
//  Copyright © 2015年 Hesse. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


enum WAPI: String {
    
    /// params: phonenumber, password
    case Register = "http://1.zhan414.sinaapp.com/?/index.php?c=main&a=graduation_register"

    /// params: phonenumber, password
    case Login = "http://1.zhan414.sinaapp.com/?/index.php?c=main&a=graduation_login"
    
    /// params: page, size = 6
    case DiscoverPics = "http://1.zhan414.sinaapp.com/?/index.php?c=main&a=graduation_Find"

}

enum WResult: String {
    case NotExist = "notexist"
    case Existed = "existed"
    case Succeed = "succeed"
    case Fail = "fail"
}

extension JSON {
    var wResult: WResult {
        return WResult(rawValue: self["result"].stringValue) ?? .Fail
    }
}


