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
    case MainMenuDirectionLeft
    
    /// 右边界
    case MainMenuDirectionRight
    
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
            
        case .MainMenuDirectionLeft: //左边界
            self.setLeftMenuViewController(menuViewController)
            
        case .MainMenuDirectionRight: //右边界
            self.setRightMenuViewController(menuViewController)
            
        }
    }
    
    /// 设置主内容视图控制器
    ///
    /// - Parameter contentViewController: 主内容视图控制器
    func setContenViewController(_ contentViewController : UIViewController) {
        
        if let contentView = contentView { //左边视图已经被设置过了
            
            //将原来的目录视图删除，并添加新的目录视图
            contentViewController.view.frame = contentView.frame
            contentView.removeFromSuperview();
            self.view.addSubview(contentViewController.view)
            self.contentView = contentViewController.view
            
        }else { //左边视图为nil，还没有被设置过
            
            self.contentView = contentViewController.view
            self.contentView?.frame = self.view.frame
            self.view.addSubview(self.contentView!)
            
        }

        
    }
    
    
}

// MARK: - ****** 定义全局常量 ******

/// 左边界目录视图Size
let leftMenuSize = CGSize(width: CZ_ScreenWidth*0.618, height: CZ_ScreenHeight)
let rightMenuSize = CGSize(width: CZ_ScreenWidth*0.618, height: CZ_ScreenHeight)


/// 主控制器类
class MainViewController: UIViewController,UIGestureRecognizerDelegate {

    // MARK: - ****** 定义属性 ******

    // MARK: 私有属性
    /// 左目录视图
    fileprivate var leftMenuView  : UIView?
    
    /// 右目录视图
    fileprivate var rightMenuView : UIView?
    
    /// 内容主视图
    fileprivate var contentView   : UIView?
    
    /// 左边界手势
    fileprivate var leftPanGestureRecognaizer  : UIScreenEdgePanGestureRecognizer!
    
    /// 右边界手势
    fileprivate var rightPanGestureRecognaizer : UIScreenEdgePanGestureRecognizer!
    
    /// 拖拽手势
    fileprivate var panGestureRecognaizer      : UIPanGestureRecognizer!
    
    /// 目录视图当前的位置
    fileprivate var menuCurrentPosistion : CGPoint?
    
    /// 当前目录视图显示类型
    fileprivate var currentDirection : DirectionType?
    
    // MARK: - ****** 生命周期 ******
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blue
        
        //初始化手势并添加
        self.leftPanGestureRecognaizer          = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(MainViewController.handleLeftEdgeGesture(_:)))
        self.leftPanGestureRecognaizer.edges    = UIRectEdge.left
        self.leftPanGestureRecognaizer.delegate = self
        self.view.addGestureRecognizer(self.leftPanGestureRecognaizer)
        
        self.rightPanGestureRecognaizer          = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(MainViewController.handleRightEdgeGesture(_:)))
        self.rightPanGestureRecognaizer.edges    = UIRectEdge.right
        self.rightPanGestureRecognaizer.delegate = self
        self.view.addGestureRecognizer(self.rightPanGestureRecognaizer)
        
        self.panGestureRecognaizer           = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        self.panGestureRecognaizer.delegate  = self
        self.panGestureRecognaizer.isEnabled = false //设置拖拽手势开始时不开启，防止和边界的两个手势冲突
        self.view.addGestureRecognizer(self.panGestureRecognaizer)
    }
    
    
    // MARK: - ****** 私有方法 ******
    
    // MARK: 手势处理方法
    
    /// 左边界手势处理
    ///
    /// - Parameter leftEdgeGesture: 手势
    @objc fileprivate func handleLeftEdgeGesture(_ leftEdgeGesture : UIScreenEdgePanGestureRecognizer) {
        //获取坐标变化值和速度
        let traslation : CGPoint = leftEdgeGesture.translation(in: leftEdgeGesture.view)
//        let velocity   : CGPoint = leftEdgeGesture.velocity(in: leftEdgeGesture.view)
        
        //判断手势状态
        switch leftEdgeGesture.state {
            
        case .began:     //手势开始状态
            
            self.menuCurrentPosistion = self.leftMenuView?.layer.position
            
        case .changed:  //手势变化状态
            
            guard let menuCurrentPosistion = menuCurrentPosistion else {
                break
            }
            let newPositionX = (menuCurrentPosistion.x + traslation.x) < leftMenuSize.width/2 ? (menuCurrentPosistion.x + traslation.x) :  leftMenuSize.width/2
            self.leftMenuView?.layer.position.x = newPositionX
            
        case .ended:   //手势结束
            
            self.menuCurrentPosistion = self.leftMenuView?.layer.position
            
            guard let menuCurrentPosistion = menuCurrentPosistion else {
                break
            }
            
            if menuCurrentPosistion.x >= leftMenuSize.width/4 {     //左边界目录视图移动的位置达到最大值，不操作
                break;
            }
            else if menuCurrentPosistion.x < leftMenuSize.width/4 { //左边界目录视图移动的位置小于自身宽度的一半，弹回
                
            }
            else if menuCurrentPosistion.x > leftMenuSize.width/4 { //左边界目录视图移动的位置大于自身宽度的一半，弹出
                
            }
            
        default:
            break
        }
    }
    
    /// 右边界手势处理
    ///
    /// - Parameter rightEdgeGesture: 手势
    @objc fileprivate func handleRightEdgeGesture(_ rightEdgeGesture : UIScreenEdgePanGestureRecognizer) {
        
    }
    
    /// 拖拽手势处理
    ///
    /// - Parameter panGesture: 手势
    @objc fileprivate func handlePanGesture(_ panGesture : UIPanGestureRecognizer) {
        
        //获取坐标变化值和速度
        let traslation : CGPoint = panGesture.translation(in: panGesture.view)
        //判断手势状态
        switch panGesture.state {
            
        case .began:     //手势开始状态
            
            self.menuCurrentPosistion = self.leftMenuView?.layer.position
            
        case .changed:  //手势变化状态
            
            guard let menuCurrenPosistion = menuCurrentPosistion else {
                break
            }
            let newPositionX = (menuCurrenPosistion.x + traslation.x) < leftMenuSize.width/2 ? (menuCurrenPosistion.x + traslation.x) :  leftMenuSize.width/2
            self.leftMenuView?.layer.position.x = newPositionX
            
        case .ended:
            break
        default:
            break
        }

        print("panGresture action")
        
    }
    
    // MARK: 添加视图控制器
    /// 设置左边界目录控制器
    ///
    /// - Parameter leftMenuViewController: 左边界控制器
    fileprivate func setLeftMenuViewController(_ leftMenuViewController : UIViewController) {
        self.addChildViewController(leftMenuViewController)
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
         self.addChildViewController(rightMenuViewController)
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

















