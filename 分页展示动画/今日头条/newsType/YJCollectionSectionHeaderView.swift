//
//  YJCollectionSectionHeaderView.swift
//  今日头条
//
//  Created by yj on 2017/1/13.
//  Copyright © 2017年 99baozi. All rights reserved.
//

import UIKit

class YJCollectionSectionHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var titleLB: UILabel!
    
    
    @IBOutlet weak var editBtn: UIButton!
    
    var sectionTitle: String? {
        didSet {
            titleLB.text = sectionTitle
        }
    }
    
    var editingNewsType: ((_ isOk: Bool)->())?
    
    
    
    @IBAction func editBtnClcik(_ sender: UIButton) {
        
        
        sender.isSelected = !sender.isSelected
        
        editingNewsType!(sender.isSelected)

        
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        editBtn.layer.cornerRadius = 10
        editBtn.layer.masksToBounds = true
        editBtn.layer.borderColor = UIColor.red.cgColor
        editBtn.layer.borderWidth = 1
        // Initialization code
    }
    
}


extension YJCollectionSectionHeaderView {
    class func collectionHeaderView() -> YJCollectionSectionHeaderView {
        return Bundle.main.loadNibNamed("YJCollectionSectionHeaderView", owner: nil, options: nil)?.first as! YJCollectionSectionHeaderView
    }
}
