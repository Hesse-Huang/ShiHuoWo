//
//  QRCodeCardVC.swift
//  Shenma
//
//  Created by Hesse on 15/11/9.
//  Copyright © 2015年 Hesse. All rights reserved.
//

import UIKit

class QRCodeCardVC: UIViewController {


    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var qrcodeImageView: UIImageView!
    @IBOutlet weak var selfieImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var signature: UILabel!
    
    private let QRCodePrefix = "ShiHuoWoUserQRCodePrefix-"
    
    var avatar: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selfieImageView.image = avatar
        selfieImageView.layer.cornerRadius = (Screen.Width - 40) / 4 / 2 - 8
        
        userName.text = User.sharedInstance.name
        signature.text = User.sharedInstance.signature
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let userID = User.sharedInstance.userID {
            if var qrcode = QRCode(QRCodePrefix + userID) {
                qrcode.errorCorrection = .High
                qrcodeImageView.image = qrcode.image
                indicator.stopAnimating()
            }
        }
    }
    
    deinit {
        NSLog("QRCodeVC deinits")
    }

}
