//
//  YJPageTitleView.swift
//  今日头条
//
//  Created by yj on 2017/1/13.
//  Copyright © 2017年 99baozi. All rights reserved.
//


import UIKit

private let kItemW  = (kScreenW - 40) / 6.0
private let kScrollLineW:CGFloat = 20
private let kScrollLineH:CGFloat = 4
protocol YJPageTitleViewDelegate {
    
    func pageTitleView(_ pageTitleView: YJPageTitleView, didSelectedItemAt index: Int)
    
    func pageTitleViewShowMoreItems(_ pageTitleView: YJPageTitleView)
    
    
}


class YJPageTitleView: UIView {
    
    var selectedBtn : UIButton?
    var delegate : YJPageTitleViewDelegate?
    
    
    // MARK:- 懒加载
    fileprivate lazy var titles : [String] = [String]()
    fileprivate lazy var titleBtns : [UIButton] = [UIButton]()
    
    
    fileprivate lazy var scrollView : UIScrollView = {
        [unowned self] in

        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.clear
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
        }()
    
    fileprivate lazy var scrollLine : UIView = {
        () in
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.red
        return scrollLine
    }()
    
    

    init(frame: CGRect , titles: [String]) {
        super.init(frame: frame)
        self.titles = titles
        
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        
    }
    
}


extension YJPageTitleView {
    // MARK:- 设置界面
    func setupUI() {
        backgroundColor = UIColor(red: 246/255, green: 245/255, blue: 244/255, alpha: 1)
        // 1.添加scrollView
        addSubview(scrollView)
        scrollView.frame = CGRect(x: 0, y: 0, width: frame.size.width - 40, height: frame.size.height)
        scrollView.contentSize = CGSize(width: kItemW * CGFloat(titles.count), height: 0)
        
        
        // 2.添加+按钮
        let addBtn = UIButton(type: .custom)
//        addBtn.backgroundColor = UIColor.white
        addBtn.frame = CGRect(x: frame.size.width - 40, y: 0, width: 40, height: 40)
        addBtn.setTitleColor(UIColor.black, for: .normal)
        addBtn.setTitle("+", for: .normal)
        addSubview(addBtn)
        addBtn.addTarget(self, action: #selector(showMenuView), for: .touchUpInside)
        
        // 3.添加title
        for (index, value) in titles.enumerated() {
            let btn = UIButton(type: .custom)
            btn.tag = index
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            btn.setTitle(value, for: .normal)
            
            btn.setTitleColor(UIColor.black, for: .normal)
            btn.setTitleColor(UIColor(red: 248/255, green: 89/255, blue: 89/255, alpha: 1), for: .selected)
            btn.frame = CGRect(x: kItemW * CGFloat(index), y: 0, width: kItemW, height: self.bounds.height)
            titleBtns.append(btn)
            btn.addTarget(self, action: #selector(selectOneItem), for: .touchUpInside)
            
            scrollView.addSubview(btn)
            
            if index == 0 {
                selectOneItem(btn)
            }
            
        }
        
        // 4.添加底部分割线
        let bottomLine = UIView(frame: CGRect(x: 0, y: frame.size.height - 0.5, width: frame.size.width, height: 0.5))
        bottomLine.backgroundColor = UIColor.lightGray
        addSubview(bottomLine)
        
        
        // 5.滚动条
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: (kItemW - kScrollLineW)*0.5, y: frame.size.height - kScrollLineH, width: kScrollLineW, height: kScrollLineH)
        
        
        
    }
}


extension YJPageTitleView {
    // MARK:- 选中按钮
    @objc fileprivate func selectOneItem(_ btn: UIButton) {
        
        // 设置按钮选中和取消效果
        self.selectedBtn?.isSelected = false
        btn.isSelected = true
        
        
//        self.selectedBtn?.transform = CGAffineTransform(scaleX: 1, y: 1)
//        btn.transform = CGAffineTransform(scaleX: 1+1/5, y: 1+1/5)
//        
        self.selectedBtn = btn
        
        // 滚动
        let index = btn.tag
        let totalTitles = self.titles.count
        
        
        UIView.animate(withDuration: 0.1) {
            self.scrollLine.frame.origin.x = (kItemW - kScrollLineW)*0.5 + kItemW*CGFloat(index)

        }
        
        
        // 标题显示滚动
        UIView.animate(withDuration: 0.2, animations: {
            () in
            
        }, completion: {
            (isCompletion : Bool) in
            
            // 设置scrollView的滚动
            UIView.animate(withDuration: 0.2){
                
                if index <= 1 {
                    self.scrollView.contentOffset = CGPoint(x: 0 , y: 0)
                }else if index > 1 && index < totalTitles - 4 {
                    self.scrollView.contentOffset = CGPoint(x: kItemW * CGFloat(index - 1) , y: 0)
                } else if index >= totalTitles - 4 {
                    self.scrollView.contentOffset = CGPoint(x: kItemW * CGFloat(totalTitles - 1 - 5) , y: 0)
                }
            }
        })
        
        
        // 执行代理
        delegate?.pageTitleView(self, didSelectedItemAt: index)
        
        
    }
    
    // MARK:- 点击+按钮
    func showMenuView() {
        delegate?.pageTitleViewShowMoreItems(self)
        
    }
    
    
}



extension YJPageTitleView  {
    
    // MARK:- 对外方法
    func setupTitleView(progress: CGFloat, sourceIndex: Int, targetIndex: Int) {

//        let sourceBtn = titleBtns[sourceIndex]
//        let targetBtn = titleBtns[targetIndex]
//
////        sourceBtn.transform = CGAffineTransform(scaleX: 1-progress/5, y: 1-progress/5)
////        targetBtn.transform = CGAffineTransform(scaleX: 1+progress/5, y: 1+progress/5)
////        
//        //
        let tempK:CGFloat = 1
        
        let maxWidth = kItemW
        
        
        
        if sourceIndex <= targetIndex { //向右 -->
            
            if progress < 0.5 {
                // 宽度增大
                scrollLine.frame.size.width =  maxWidth*progress/(0.5*tempK) + kScrollLineW
                
                
            } else {
                
                // 宽度减小
                scrollLine.frame.size.width = kScrollLineW + maxWidth - maxWidth*(progress-0.5)/(0.5*tempK)
                
                
                //x增大
                scrollLine.frame.origin.x = (kItemW - kScrollLineW)*0.5 + kItemW*CGFloat(targetIndex-1) + maxWidth*(progress-0.5)/(0.5*tempK)
                
                
            }
        } else { // 向左 <--
            if progress > 0.5 {
                scrollLine.frame.origin.x = (kItemW - kScrollLineW)*0.5 + kItemW*CGFloat(sourceIndex) - maxWidth*0.5/(0.5*tempK)
                
                // 宽度减小
                scrollLine.frame.size.width = kScrollLineW + maxWidth - maxWidth*(progress-0.5)/(0.5*tempK)
            } else {
                // 宽度增大
                scrollLine.frame.size.width =  maxWidth*progress/(0.5*tempK) + kScrollLineW
                
                // x减小
                scrollLine.frame.origin.x = (kItemW - kScrollLineW)*0.5 + kItemW*CGFloat(sourceIndex) - maxWidth*progress/(0.5*tempK)
                
            }
            
        }

        
        
        
        
        

    }

    func setupSelectedItem(_ index: Int) {

        self.selectOneItem(titleBtns[index])
        
        
    }
    
}






