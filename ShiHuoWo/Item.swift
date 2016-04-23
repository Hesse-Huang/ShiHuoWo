//
//  Item.swift
//  ShiHuoWo
//
//  Created by Hesse on 16/3/3.
//  Copyright © 2016年 Hesse. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct Item {

    private(set) var name: String?
    private(set) var description: String?
    private(set) var picturePaths: [String]?
    
    private(set) var currentPrice: Double?
    private(set) var previousPrice: Double?
    
    private(set) var shopName: String?
    
    
    // FIXME: Unfinished definition
    init(json: JSON) {
        self.name = json["name"].stringValue
        self.description = json["description"].stringValue
        self.picturePaths = json["pics"].arrayObject as! [String]
        self.currentPrice = json["current_price"].doubleValue
        self.previousPrice = json["previous_pricw"].doubleValue
        self.shopName = json["shop_name"].stringValue
    }
    
    init() {
        
    }
    
}
