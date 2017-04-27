//
//  YJPageContentView.swift
//  今日头条
//
//  Created by yj on 2017/1/13.
//  Copyright © 2017年 99baozi. All rights reserved.
//

import UIKit
private let kPageContentViewCell = "kPageContentViewCell"

protocol YJPageContentViewDelegate {
    func pageContentView(_ pageContentView: YJPageContentView, progress:CGFloat, sourceIndex: Int, targetIndex: Int)
    
    func pageContentViewDidEndDecelerating(_ pageContentView: YJPageContentView, targetIndex: Int)
    
}

class YJPageContentView: UIView {
    
    var childVcs : [UIViewController] = []
    var delegate : YJPageContentViewDelegate?
    fileprivate var startOffsetX : CGFloat = 0
    fileprivate var targetIndex : Int = 0
    
    fileprivate var isForbidScrollDelegate : Bool = false
    
    
    fileprivate lazy var collectionView : UICollectionView = {
        () in
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = self.bounds.size
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kPageContentViewCell)
        
        
        return collectionView
    }()
    
    init(frame: CGRect, parentController: UIViewController) {
        super.init(frame: frame)
        
        self.childVcs = parentController.childViewControllers
        
        addSubview(collectionView)
        collectionView.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
}


extension YJPageContentView  {
    // MARK:- 对外暴露
    func setSelectedPageIndex(_ index: Int) {
        isForbidScrollDelegate = true
        
        if index >= childVcs.count { return }
        
        collectionView.scrollToItem(at: NSIndexPath(item: index, section: 0) as IndexPath, at: .centeredHorizontally, animated: true)
        
        
    }
    
    
}



extension YJPageContentView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPageContentViewCell, for: indexPath)
        
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        
        let vc = childVcs[indexPath.row]
        vc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(vc.view)
        
        
        
        return cell
        
    }
    
}

extension YJPageContentView : UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isForbidScrollDelegate = false
        
        startOffsetX = scrollView.contentOffset.x
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isForbidScrollDelegate {
            return
        }
        
        // 1.定义获取需要的数据
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        
        
        // 2.判断是左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currentOffsetX > startOffsetX { // 左滑
            // 1.计算progress
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            
            // 2.计算sourceIndex
            sourceIndex = Int(currentOffsetX / scrollViewW)
            
            // 3.计算targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count {
                targetIndex = childVcs.count - 1
            }
            
            // 4.如果完全划过去
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
        } else { // 右滑
            // 1.计算progress
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            
            // 2.计算targetIndex
            targetIndex = Int(currentOffsetX / scrollViewW)
            
            // 3.计算sourceIndex
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVcs.count {
                sourceIndex = childVcs.count - 1
            }
        }
        
        
        
        
        // 调用代理
        delegate?.pageContentView(self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        delegate?.pageContentViewDidEndDecelerating(self, targetIndex: targetIndex)
    }
    
    
}
