//
//  WoCell.swift
//  ShiHuoWo
//
//  Created by Hesse on 16/2/28.
//  Copyright © 2016年 Hesse. All rights reserved.
//

import UIKit
import Kingfisher

protocol WoCellLikeDelegate: class {
    func woCell(woCell: WoCell, didTapLike like: Bool)
}

class WoCell: UITableViewCell {
    
    struct Cache {
        static let RedHeart = UIImage(named: "RedHeart")
        static let WhiteHeart = UIImage(named: "WhiteHeart")
        static let RedHeartColor = UIColor(red: 200 / 255, green: 53 / 255, blue: 43 / 255, alpha: 1.0)
        static let WhiteColor = UIColor.whiteColor()
    }

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var heartImageView: UIImageView!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    weak var delegate: WoCellLikeDelegate?
    
    var row: Int!
    
    func customizeWithImageURLString(string: String, title: String, like: WoGoodsLike, row: Int) {
        guard let url = NSURL(string: string) else { return }
        mainImageView.kf_showIndicatorWhenLoading = true
        mainImageView.kf_setImageWithURL(url, placeholderImage: nil, optionsInfo: [.Transition(.Fade(0.3))], completionHandler: nil)
        
        bottomLabel.text = title
        
        likeButton.selected = like.0
        heartImageView.image = like.0 ? Cache.RedHeart : Cache.WhiteHeart
        likeCountLabel.text = String(like.1)
        likeCountLabel.textColor = like.0 ? Cache.RedHeartColor : Cache.WhiteColor
        
        self.row = row
    }

    @IBAction func handleLike(sender: AnyObject) {
        likeButton.selected = !likeButton.selected
        heartImageView.image = likeButton.selected ? Cache.RedHeart : Cache.WhiteHeart
        likeCountLabel.textColor = likeButton.selected ? Cache.RedHeartColor : Cache.WhiteColor
        
        if let text = likeCountLabel.text, var count = Int(text) {
            count += likeButton.selected ? 1 : -1
            likeCountLabel.text = String(count)
        }
        if likeButton.selected {
            animateRedHeart()
        }
        delegate?.woCell(self, didTapLike: likeButton.selected)
    }
    
    private func animateRedHeart() {
        UIView.animateWithDuration(0.15, animations: {
            self.heartImageView.transform = CGAffineTransformMakeScale(1.4, 1.4)
            }, completion: { _ in
                UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
                    self.heartImageView.transform = CGAffineTransformIdentity
                    }, completion: nil)
        })
    }
    
    
}

