//
//  YJNewsTypeViewController.swift
//  今日头条
//
//  Created by yj on 2017/1/16.
//  Copyright © 2017年 99baozi. All rights reserved.
//

import UIKit


private let reuseIdentifier = "YJMoreItemsViewCell"
private let itemSectionHeaderID = "YJMoreItemsViewSectionHeader"

class YJNewsTypeViewController: UICollectionViewController {

     fileprivate lazy var dataSource : [YJNewsTypeModel] = YJNewsTypeViewModel().newsTypeArray!
    
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (kScreenW - 15 * 5) / 4 , height: 30)
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        layout.headerReferenceSize = CGSize(width: kScreenW - 15 * 2, height: 35)
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.register(UINib(nibName: "YJNewsTypeCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)

        collectionView?.contentInset = UIEdgeInsetsMake(0, 15, 0, 15)
        collectionView?.backgroundColor = UIColor.white
       
        
        
        collectionView?.register(UINib(nibName: "YJCollectionSectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: itemSectionHeaderID)


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}



// MARK:- UICollectionViewDataSource
extension YJNewsTypeViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! YJNewsTypeCell
        cell.titleLb.text = dataSource[indexPath.section].items[indexPath.item]
        
        if indexPath.section == 0 && indexPath.item == 0 {
            cell.titleLb.textColor = UIColor.lightGray
        } else {
            cell.titleLb.textColor = UIColor.black
        }
        
        
        if indexPath.section == 0 {
            if dataSource[indexPath.section].isEditing {
                cell.cancelIcon.isHidden = false
            } else {
                cell.cancelIcon.isHidden = true
                
            }
            
        } else {
            cell.cancelIcon.isHidden = true
        }
        
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: itemSectionHeaderID, for: indexPath) as! YJCollectionSectionHeaderView
        sectionHeader.editingNewsType = {
            [weak self] (isOk: Bool) in
            
            
            self?.dataSource[0].isEditing = isOk
            
            collectionView.reloadData()

            
        }
        
        sectionHeader.titleLB.text = dataSource[indexPath.section].title
        
        if indexPath.section == 0 {
            sectionHeader.editBtn.isHidden = false
            sectionHeader.editBtn.isSelected = dataSource[indexPath.section].isEditing
        } else {
            sectionHeader.editBtn.isHidden = true
        }
        
        return sectionHeader
    }
    
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        

        
        if indexPath.section == 0 {

            if dataSource[0].isEditing  {
                
                if indexPath.item == 0 { return false }

                
                return true
            }
            
        }
        return false

    }
    
   override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        
        dataSource[destinationIndexPath.section].items.insert(dataSource[sourceIndexPath.section].items.remove(at: sourceIndexPath.item), at: destinationIndexPath.item)

    
        
        collectionView.reloadData()
        
    }
    
    
    

}







extension YJNewsTypeViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if dataSource[0].isEditing {
            if indexPath.section == 0 {
                dataSource[0].items.remove(at: indexPath.item)
                collectionView.deleteItems(at: [indexPath])
                
            } else if indexPath.section == 1 {
                
                
                dataSource[0].items.append(dataSource[1].items.remove(at: indexPath.item))
//                collectionView.deleteItems(at: [indexPath])
                collectionView.reloadData()
                
                
                
            }
            
            
        }
        
        
        
        
    }
}
