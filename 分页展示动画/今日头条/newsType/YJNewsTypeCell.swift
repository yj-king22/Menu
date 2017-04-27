//
//  YJNewsTypeCell.swift
//  今日头条
//
//  Created by yj on 2017/1/13.
//  Copyright © 2017年 99baozi. All rights reserved.
//

import UIKit

class YJNewsTypeCell: UICollectionViewCell {

    @IBOutlet weak var titleLb: UILabel!
    
    
    @IBOutlet weak var cancelIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLb.layer.cornerRadius = 1
        titleLb.layer.masksToBounds = true
        titleLb.layer.borderColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1).cgColor
        titleLb.layer.borderWidth = 0.5

    }

}
