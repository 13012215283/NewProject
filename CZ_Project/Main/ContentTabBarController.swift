//
//  ContentTabBarController.swift
//  CZ_Project
//
//  Created by zol on 2017/7/6.
//  Copyright © 2017年 zol. All rights reserved.
//

import UIKit

class ContentTabBarController: UITabBarController {
    
// MARK: - ****** 定义属性 ******
    
    // MARK: 公有属性
    lazy var testVC1 : UINavigationController = {
        let vc = UINavigationController(rootViewController: TestViewController1())
        return vc
    }()
    
    lazy var testVC2 : UINavigationController = {
        let vc = UINavigationController(rootViewController: TestViewController2())
        return vc
    }()
    
    lazy var testVC3 : UINavigationController = {
        let vc = UINavigationController(rootViewController: TextViewController3())
        return vc
    }()
    
    
// MARK: - ****** 构造方法 ******
    init() {
        super.init(nibName: nil, bundle: nil)
        //设置子视图
        setViewControllers([testVC1, testVC2, testVC3], animated: false)
        
        //隐藏tabBar
        tabBar.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
// MARK: - ****** 生命周期 ******
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

// MARK: - ****** 公有方法 ******
    /// 设置子视图
    func setChildViewController() {
        setViewControllers([testVC1, testVC2, testVC3], animated: false)
    }
    
   
}
