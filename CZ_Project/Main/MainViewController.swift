//
//  MainViewController.swift
//  CZ_Project
//
//  Created by zol on 2017/6/27.
//  Copyright © 2017年 zol. All rights reserved.
//

import UIKit

enum DirectionType {
    
    /// 左边界
    case DirectionLeft
    
    /// 右边界
    case DirectionRight
    
}

// MARK: - ****** 公有方法接口 ******
extension MainViewController {
    
    /// 设置目录控制器
    ///
    /// - Parameters:
    ///   - menuViewController: 目录控制器
    ///   - type: 设置边界 左边界(DirectionLeft)，右边界(DirectionRight)
    func setMenuViewController(_ menuViewController : UIViewController, withDerectionType type : DirectionType) {
        
        switch type { //判断目录控制器类型
            
        case .DirectionLeft: //左边界
            self.setLeftMenuViewController(menuViewController)
            
        case .DirectionRight: //右边界
            self.setRightMenuViewController(menuViewController)
            
        }
    }
    
    
    
}

// MARK: - ****** 定义全局常量 ******

/// 左边界目录视图Size
let leftMenuSize = CGSize(width: CZ_ScreenWidth*0.618, height: CZ_ScreenHeight)
let rightMenuSize = CGSize(width: CZ_ScreenWidth*0.618, height: CZ_ScreenHeight)


class MainViewController: UIViewController {

    // MARK: - ****** 定义属性 ******

    // MARK: 私有属性
    /// 左目录视图
    fileprivate var leftMenuView  : UIView?
    
    /// 右目录视图
    fileprivate var rightMenuView : UIView?
    
    /// 内容主视图
    fileprivate var contentView   : UIView?
    
    /// 左边界手势
    fileprivate var leftPanGestureRecognaizer : UIScreenEdgePanGestureRecognizer!
    
    /// 右边界手势
    fileprivate var rightPanGestureRecognaizer : UIScreenEdgePanGestureRecognizer!
    
    // MARK: - ****** 生命周期 ******
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        
        //初始化手势并添加
        self.leftPanGestureRecognaizer  = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(MainViewController.handleLeftEdgeGesture(_:)))
        self.rightPanGestureRecognaizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(MainViewController.handleRightEdgeGesture(_:)))
        self.view.addGestureRecognizer(self.leftPanGestureRecognaizer)
        self.view.addGestureRecognizer(self.rightPanGestureRecognaizer)
        
    }
    
    
    // MARK: - ****** 私有方法 ******
    
    // MARK: 手势处理方法
    
    /// 左边界手势处理
    ///
    /// - Parameter leftEdgeGesture: 手势
    @objc fileprivate func handleLeftEdgeGesture(_ leftEdgeGesture : UIScreenEdgePanGestureRecognizer) {
        
    }
    
    /// 右边界手势处理
    ///
    /// - Parameter rightEdgeGesture: 手势
    @objc fileprivate func handleRightEdgeGesture(_ rightEdgeGesture : UIScreenEdgePanGestureRecognizer) {
        
    }
    
    // MARK: 添加视图控制器
    /// 设置左边界目录控制器
    ///
    /// - Parameter leftMenuViewController: 左边界控制器
    fileprivate func setLeftMenuViewController(_ leftMenuViewController : UIViewController) {
        
        if let leftMenuView = leftMenuView { //左边视图已经被设置过了
            
            //将原来的目录视图删除，并添加新的目录视图
            leftMenuViewController.view.frame = leftMenuView.frame
            leftMenuView.removeFromSuperview();
            self.view.addSubview(leftMenuViewController.view)
            self.leftMenuView = leftMenuViewController.view
            
        }else { //左边视图为nil，还没有被设置过
            self.leftMenuView = leftMenuViewController.view
            self.leftMenuView?.frame = CGRect(x: -leftMenuSize.width, y: 0, width: leftMenuSize.width, height: leftMenuSize.height)
            self.view.addSubview(self.leftMenuView!)
        }
        
    }
    
    /// 设置右边界目录控制器
    ///
    /// - Parameter RightMenuViewController: 右边界控制器
    fileprivate func setRightMenuViewController(_ rightMenuViewController : UIViewController) {
        if let rightMenuView = rightMenuView { //左边视图已经被设置过了
            
            //将原来的目录视图删除，并添加新的目录视图
            rightMenuViewController.view.frame = rightMenuView.frame
            rightMenuView.removeFromSuperview();
            self.view.addSubview(rightMenuViewController.view)
            self.rightMenuView = rightMenuViewController.view
            
        }else { //左边视图为nil，还没有被设置过
            
            self.rightMenuView = rightMenuViewController.view
            self.rightMenuView?.frame = CGRect(x: CZ_ScreenWidth, y: 0, width: rightMenuSize.width, height: rightMenuSize.height)
            self.view.addSubview(self.rightMenuView!)
            
        }

    }


}



















