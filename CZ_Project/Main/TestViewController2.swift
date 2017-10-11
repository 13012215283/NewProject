//
//  TestViewController2.swift
//  CZ_Project
//
//  Created by zol on 2017/10/11.
//  Copyright © 2017年 zol. All rights reserved.
//

import UIKit

class TestViewController2: PageScrollViewController {

    convenience init(currentIndex : Int) {
        self.init()
        pageScrollViewManager.currentControllerIndex = currentIndex
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        let leftButton1 = UIButton()
        leftButton1.backgroundColor = UIColor.blue
        
        let leftButton2 = UIButton()
        leftButton2.backgroundColor = UIColor.red
        
        let leftButton3 = UIButton()
        leftButton3.backgroundColor = UIColor.blue
        
        let leftButton4 = UIButton()
        leftButton4.backgroundColor = UIColor.red
        
        
        let rightButton1 = UIButton()
        rightButton1.backgroundColor = UIColor.yellow
        
        let rightButton2 = UIButton()
        rightButton2.backgroundColor = UIColor.green
        
        let rightButton3 = UIButton()
        rightButton3.backgroundColor = UIColor.yellow
        
        let rightButton4 = UIButton()
        rightButton4.backgroundColor = UIColor.green
        
        let vc1 = UIViewController()
        vc1.view.backgroundColor = UIColor.blue
        
        let vc2 = UIViewController()
        vc2.view.backgroundColor = UIColor.red
        
        let vc3 = UIViewController()
        vc3.view.backgroundColor = UIColor.gray
        
        let vc4 = UIViewController()
        vc4.view.backgroundColor = UIColor.yellow
        
        let vc5 = UIViewController()
        vc5.view.backgroundColor = UIColor.green
        
        
        pageScrollViewManager.titleLeftInterval = 10
        pageScrollViewManager.titleRightInterval = 10
        pageScrollViewManager.titleTextColor = UIColor(red: 0, green: 0, blue: 1, alpha: 1)
        pageScrollViewManager.selectTitleTextColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        addChildPageViewController(vc1, title: "标题0", leftButtons: [leftButton1], rightButtons: [rightButton1])
        addChildPageViewController(vc2, title: "标题标题1", leftButtons: [leftButton2, leftButton3], rightButtons: [rightButton2, rightButton3])
        addChildPageViewController(vc3, title: "标题标题标题2", leftButtons: [leftButton4], rightButtons: nil)
        addChildPageViewController(vc4, title: "标题标题3", leftButtons: nil, rightButtons: nil)
        addChildPageViewController(vc5, title: "标题标题4", leftButtons: nil, rightButtons: [rightButton4])
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func pageScrollViewIsHidden(viewControllerInfo: PageViewControllerInfo, index: NSInteger) {
        
        super.pageScrollViewIsHidden(viewControllerInfo: viewControllerInfo, index: index)
        
    }
    
    override func pageScrollViewIsShowing(newViewControllerInfo: PageViewControllerInfo, index: NSInteger) {
        
        super.pageScrollViewIsShowing(newViewControllerInfo: newViewControllerInfo, index: index)
        
    }
    
    override func pageScrollViewCurrentViewControllerChange(newViewControllerInfo: PageViewControllerInfo, newindex: NSInteger, lastViewControllerInfo: PageViewControllerInfo, lastindex: NSInteger) {
        
        super.pageScrollViewCurrentViewControllerChange(newViewControllerInfo: newViewControllerInfo, newindex: newindex, lastViewControllerInfo: lastViewControllerInfo, lastindex: lastindex)
        
    }

}

