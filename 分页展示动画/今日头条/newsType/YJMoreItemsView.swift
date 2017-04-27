//
//  YJMoreItemsView.swift
//  今日头条
//
//  Created by yj on 2017/1/13.
//  Copyright © 2017年 99baozi. All rights reserved.
//

import UIKit
private let itemCellID = "YJMoreItemsViewCell"
private let itemSectionHeaderID = "YJMoreItemsViewSectionHeader"

class YJMoreItemsView: UIView {

    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var bottomLine: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var alphaView: UIView!
    
    var isEditing = false
    
    
    
    fileprivate lazy var dataSource : [YJNewsTypeModel] = YJNewsTypeViewModel().newsTypeArray!
    
        
        
    override func awakeFromNib() {
        
        collectionView.register(UINib(nibName: "YJNewsTypeCell", bundle: nil), forCellWithReuseIdentifier: itemCellID)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsetsMake(64, 20, 0, 20)
        
        
        
        collectionView.register(UINib(nibName: "YJCollectionSectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: itemSectionHeaderID)
        
        super.awakeFromNib()

    }
    
    
    class func moreItemsView() -> YJMoreItemsView {
        return Bundle.main.loadNibNamed("YJMoreItemsView", owner: nil, options: nil)?.first as! YJMoreItemsView
    }
    

    @IBAction func backBtnClcik(_ sender: UIButton) {
        
        removeFromSuperview()
    }
    

}

// MARK:- UICollectionViewDataSource
extension YJMoreItemsView: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCellID, for: indexPath) as! YJNewsTypeCell
        cell.titleLb.text = dataSource[indexPath.section].items[indexPath.item]
        
        if indexPath.section == 0 {
            if isEditing {
                cell.cancelIcon.isHidden = false
            } else {
                cell.cancelIcon.isHidden = true

            }
            
        } else {
            cell.cancelIcon.isHidden = true
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: itemSectionHeaderID, for: indexPath) as! YJCollectionSectionHeaderView
        sectionHeader.editingNewsType = {
            [weak self] (isOk: Bool) in
            
            self?.isEditing = isOk
            if isOk { // 点击完成
                print("完成编辑，退出")
//                self?.removeFromSuperview()
                collectionView.reloadData()

                
            } else {
                
                print("开始编辑")
                collectionView.reloadData()

            }
            
        }
        
        sectionHeader.titleLB.text = dataSource[indexPath.section].title

        if indexPath.section == 0 {
            sectionHeader.editBtn.isHidden = false
        } else {
            sectionHeader.editBtn.isHidden = true
        }
        
        return sectionHeader
    }
    
    
    
}
// MARK:- UICollectionViewDelegate
extension YJMoreItemsView: UICollectionViewDelegate{
  
    
    
    
    // 控制bar透明度
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("=====\(scrollView.contentOffset.y)")
        
        
        if scrollView.contentOffset.y > -54 {
            bottomLine.isHidden = false
            alphaView.alpha = 0.95
        } else {
            bottomLine.isHidden = true
            alphaView.alpha = 1
        }
        
    }
    

}

