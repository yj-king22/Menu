//
//  YJHomeViewController.swift
//  今日头条
//
//  Created by yj on 2017/1/13.
//  Copyright © 2017年 99baozi. All rights reserved.
//

import UIKit
private let kTitleViewH : CGFloat = 40

class YJHomeViewController: UIViewController {

    // MARK:- 懒加载属性
    fileprivate lazy var pageTitleView : YJPageTitleView = {
        [weak self] in
        let titleFrame = CGRect(x: 0, y: 0, width: kScreenW, height: kTitleViewH)
        let titles = ["推荐", "视频", "热点", "上海", "社会", "体育", "科技", "军事"]
        let titleView = YJPageTitleView(frame: titleFrame, titles: titles)
        titleView.delegate = self
        return titleView
        }()
    
    fileprivate lazy var pageContentView : YJPageContentView = {
        
        let test1 = YJTest1ViewController()
        test1.desc = "推荐"
        self.addChildViewController(test1)
        
        let test2 = YJTest2ViewController()
        test2.desc = "视频"
        self.addChildViewController(test2)
        
        let test3 = YJTest3ViewController()
        test3.desc = "热点"
        self.addChildViewController(test3)

        let test4 = YJTest4ViewController()
        test4.desc = "上海"
        self.addChildViewController(test4)
        
        let test5 = YJTest5ViewController()
        test5.desc = "社会"
        self.addChildViewController(test5)
        
        let test6 = YJTest6ViewController()
        test6.desc = "体育"
        self.addChildViewController(test6)
        
        let test7 = YJTest7ViewController()
        test7.desc = "科技"
        self.addChildViewController(test7)
        
        let test8 = YJTest8ViewController()
        test8.desc = "军事"
        self.addChildViewController(test8)

        
        let pageContentView = YJPageContentView(frame: CGRect(x: 0, y: kTitleViewH, width: kScreenW, height: kScreenH - kTitleViewH - kNavigationBarH), parentController: self)
        
        pageContentView.delegate = self
        
        return pageContentView
        
    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}



extension YJHomeViewController {
    func setupUI() {
        view.backgroundColor = UIColor.white
        
        navigationController?.navigationBar.isTranslucent=false
        let imgView = UIImageView(image: UIImage(named: "titleImage"))
        imgView.bounds = CGRect(x: 0, y: 0, width: 90, height: 25)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: imgView)
        

        
        let searchBtn = UIButton(type: .custom)
        searchBtn.imageView?.contentMode = .center
        searchBtn.contentHorizontalAlignment = .left
        searchBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        searchBtn.isHighlighted = false
        searchBtn.frame = CGRect(x: 0, y: 0, width: kScreenW - 150, height: 30)
        
        
        searchBtn.setImage(UIImage(named:"search"), for: .normal)
        searchBtn.setImage(UIImage(named:"search"), for: .highlighted)
        searchBtn.setTitle("搜你想搜的", for: .normal)
        searchBtn.setTitleColor(UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1), for: .normal)
        searchBtn.backgroundColor = UIColor(red: 246/255, green: 245/255, blue: 244/255, alpha: 1)
       searchBtn.layer.cornerRadius = 4
        searchBtn.clipsToBounds = true
        
        navigationItem.rightBarButtonItem =  UIBarButtonItem(customView: searchBtn)
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 212/255, green: 61/255, blue: 61/255, alpha: 1)
        
        view.addSubview(pageTitleView)
        view.addSubview(pageContentView)

        
    }
    
}

// MARK: YJPageTitleViewDelegate
extension YJHomeViewController: YJPageTitleViewDelegate {
    // MARK:- 点击item title按钮
    func pageTitleView(_ pageTitleView: YJPageTitleView, didSelectedItemAt index: Int) {
        
        pageContentView.setSelectedPageIndex(index)
        
    }
    
    // MARK:- 显示跟多菜单
    func pageTitleViewShowMoreItems(_ pageTitleView: YJPageTitleView) {
        
//        let moreItemView = YJMoreItemsView.moreItemsView()
//        moreItemView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH - 64)
//        
////        let window = UIApplication().windows.first
//        view.addSubview(moreItemView)
        
        let newsTypeVC = YJNewsTypeViewController()
        
        self.navigationController?.pushViewController(newsTypeVC, animated: true)
        

        
        
    }

}

// MARK:-YJPageContentViewDelegate
extension YJHomeViewController : YJPageContentViewDelegate {
    
    func pageContentView(_ pageContentView: YJPageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setupTitleView(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
    func pageContentViewDidEndDecelerating(_ pageContentView: YJPageContentView, targetIndex: Int) {
        
        pageTitleView.setupSelectedItem(targetIndex)
    }
    
    
    
    
}














