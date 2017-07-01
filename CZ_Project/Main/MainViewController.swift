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
            setLeftMenuViewController(menuViewController)
            
        case .MainMenuDirectionRight: //右边界
            setRightMenuViewController(menuViewController)
            
        }
    }
    
    /// 设置主内容视图控制器
    ///
    /// - Parameter contentViewController: 主内容视图控制器
    func setContenViewController(_ contentViewController : UIViewController) {
        addChildViewController(contentViewController)
        if let _ = contentView { //左边视图已经被设置过了
            //将原来的目录视图删除，并添加新的目录视图
            contentView?.removeFromSuperview();
            
        }
        view.addSubview(contentViewController.view)
        contentView = contentViewController.view
        contentView?.frame = view.frame
        
    }

}

// MARK: - ****** 定义全局常量 ******

/// 左边界目录视图Size
let leftMenuSize = CGSize(width: CZ_ScreenWidth*0.618, height: CZ_ScreenHeight)
let rightMenuSize = CGSize(width: CZ_ScreenWidth*0.618, height: CZ_ScreenHeight)

/// 左边界视图插束长
let converWidth = CZ_ScreenWidth/3.0

/// 右边界视图初始x坐标
let leftMenuViewX = (-CZ_ScreenWidth + converWidth)

/// 弹簧长度
let dampingW : CGFloat = 10.0


// MARK: - ****** 主控制器类 ******
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
        
        view.backgroundColor    = UIColor.blue
        
        //初始化手势并添加
        leftPanGestureRecognaizer          = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(MainViewController.handleLeftEdgeGesture(_:)))
        leftPanGestureRecognaizer.edges    = UIRectEdge.left
        leftPanGestureRecognaizer.delegate = self
        view.addGestureRecognizer(leftPanGestureRecognaizer)
        
        rightPanGestureRecognaizer          = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(MainViewController.handleRightEdgeGesture(_:)))
        rightPanGestureRecognaizer.edges    = UIRectEdge.right
        rightPanGestureRecognaizer.delegate = self
        view.addGestureRecognizer(rightPanGestureRecognaizer)
        
        panGestureRecognaizer           = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGestureRecognaizer.delegate  = self
        panGestureRecognaizer.isEnabled = false //设置拖拽手势开始时不开启，防止和边界的两个手势冲突
        view.addGestureRecognizer(panGestureRecognaizer)
    }
    
    
    // MARK: - ****** 私有方法 ******
    
    // MARK: 添加视图控制器
    /// 设置左边界目录控制器
    ///
    /// - Parameter leftMenuViewController: 左边界控制器
    fileprivate func setLeftMenuViewController(_ leftMenuViewController : UIViewController) {
        addChildViewController(leftMenuViewController)
        
        if let leftMenuView = leftMenuView { //左边视图已经被设置过了
            //将原来的目录视图删除
            leftMenuView.removeFromSuperview();
        }
    
        view.insertSubview(leftMenuViewController.view, at: 0)
        leftMenuView = leftMenuViewController.view
        leftMenuView?.frame.origin =  CGPoint(x: leftMenuViewX, y: 0)
    }
    
    /// 设置右边界目录控制器
    ///
    /// - Parameter RightMenuViewController: 右边界控制器
    fileprivate func setRightMenuViewController(_ rightMenuViewController : UIViewController) {
        addChildViewController(rightMenuViewController)
        if let rightMenuView = rightMenuView { //左边视图已经被设置过了
            //将原来的目录视图删除
            rightMenuView.removeFromSuperview();
            
        }
        view.addSubview(rightMenuViewController.view)
        rightMenuView = rightMenuViewController.view
        rightMenuView?.frame.origin = CGPoint(x: -rightMenuViewController.view.frame.size.width, y: 0)

    }

    
    // MARK: 手势处理方法
    
    /// 左边界手势处理
    ///
    /// - Parameter leftEdgeGesture: 手势
    @objc fileprivate func handleLeftEdgeGesture(_ leftEdgeGesture : UIScreenEdgePanGestureRecognizer) {
        //获取坐标变化值和速度
        let traslation : CGPoint = leftEdgeGesture.translation(in: leftEdgeGesture.view)
        
        //判断手势状态
        switch leftEdgeGesture.state {
            
        case .began:     //手势开始状态
            
            menuCurrentPosistion = leftMenuView?.frame.origin
            
        case .changed:   //手势变化状态
            
           leftMenuViewAnimation(traslation: traslation)
            
        case .ended:     //手势结束
            
           leftMenuViewHadFinishedMove()

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
            
            menuCurrentPosistion = leftMenuView?.frame.origin
            
        case .changed:   //手势变化状态
            
            leftMenuViewAnimation(traslation: traslation)
            
        default:         //手势结束
            leftMenuViewHadFinishedMove()
        }
        
    }
    
    
    // MARK: - ****** 目录动画 ******
    /// 关闭左边界目录
    fileprivate func closeLeftMenuView() {
        
        let duration = (leftMenuView!.frame.maxX - converWidth)/CZ_ScreenWidth * 1.5

        UIView.animate(withDuration: TimeInterval(duration), delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
            self.leftMenuView!.frame.origin.x = leftMenuViewX
            self.contentView?.frame.origin.x  = 0
        }){ (finished: Bool) in
            self.panGestureRecognaizer.isEnabled = false
        }

    }
    
    /// 开启左边界目录
    fileprivate func showLeftMenuview() {
        
        let duration = (leftMenuSize.width - leftMenuView!.frame.maxX + dampingW)/CZ_ScreenWidth * 1.5
        UIView.animate(withDuration: TimeInterval(duration), delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.leftMenuView!.frame.origin.x = -self.leftMenuView!.frame.size.width + leftMenuSize.width + dampingW
            //计算内容主视图的x坐标
            let newContentX = (-self.leftMenuView!.frame.size.width + leftMenuSize.width + dampingW - leftMenuViewX)/(leftMenuSize.width - converWidth + dampingW) * (leftMenuSize.width + dampingW)
            self.contentView?.frame.origin.x  = newContentX
        }){ (finished: Bool) in
            self.leftMenuViewShowDampingAnimation()
        }
    }
    
    /// 左边视图弹出动画完成，添加阻尼动画
    fileprivate func leftMenuViewShowDampingAnimation() {
        let duration = dampingW / CZ_ScreenWidth * 2
        
        UIView.animate(withDuration: TimeInterval(duration), delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.leftMenuView!.frame.origin.x = -self.leftMenuView!.frame.size.width + leftMenuSize.width
            let newContentX = (-self.leftMenuView!.frame.size.width + leftMenuSize.width - leftMenuViewX)/(leftMenuSize.width - converWidth + dampingW) * (leftMenuSize.width + dampingW)
            self.contentView?.frame.origin.x  = newContentX
            
        }){ (finished: Bool) in
            self.panGestureRecognaizer.isEnabled = true
        }
    }
    
    /// 左边视图弹出动画完成，添加回弹阻尼动画
    fileprivate func leftMenuViewShowReboundDampingAnimation() {
        //计算超出最大限制的距离
//        let outDistance = leftMenuView!.frame.origin.x - (-leftMenuView!.frame.size.width + leftMenuSize.width)
        
        let duration = dampingW / CZ_ScreenWidth * 2
        
        UIView.animate(withDuration: TimeInterval(duration), delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.leftMenuView!.frame.origin.x = -self.leftMenuView!.frame.size.width + leftMenuSize.width - dampingW
            let newContentX = (-self.leftMenuView!.frame.size.width + leftMenuSize.width - dampingW - leftMenuViewX)/(leftMenuSize.width - converWidth + dampingW) * (leftMenuSize.width + dampingW)
            self.contentView?.frame.origin.x  = newContentX
            
        }){ (finished: Bool) in
            self.leftMenuViewShowDampingAnimation()
        }
    }
    
    
    
    /// 左边界目录位移动画
    ///
    /// - Parameter traslation: 变化量
    fileprivate func leftMenuViewAnimation(traslation : CGPoint) {
        
        guard let menuCurrentPosistion = menuCurrentPosistion, let leftMenuView = leftMenuView else {
            return
        }
       
        //左边界目录的新x坐标
        let newPositionX = (menuCurrentPosistion.x + leftMenuView.frame.size.width + traslation.x) < (leftMenuSize.width + dampingW) ? (menuCurrentPosistion.x + traslation.x) : (-leftMenuView.frame.size.width + leftMenuSize.width + dampingW)
        leftMenuView.frame.origin.x = newPositionX > leftMenuViewX ? newPositionX : leftMenuViewX
        
        //计算内容主视图的x坐标
        let newContentX = (newPositionX - leftMenuViewX)/(leftMenuSize.width - converWidth + dampingW) * (leftMenuSize.width + dampingW)
        contentView?.frame.origin.x = newContentX > 0 ? newContentX : 0
    }
    
    /// 左边界目录位移完成(拖拽手势完成后)
    fileprivate func leftMenuViewHadFinishedMove() {
        
        menuCurrentPosistion = leftMenuView?.frame.origin
        
        guard let contentView = contentView else {
            return
        }

        if contentView.frame.origin.x == 0 {                            //左边界目录视图移动的位置达到最小值，关闭拖拽手势
            panGestureRecognaizer.isEnabled = false
            
        }
        else if contentView.frame.origin.x < leftMenuSize.width/2.0 {   //左边界目录视图移动的位置小于自身宽度的一半，弹回
            closeLeftMenuView()
            
        }
        else if contentView.frame.origin.x >= leftMenuSize.width/2.0 && contentView.frame.origin.x <= leftMenuSize.width{ //左边界目录视图移动的位置大于自身一半且小于最大值，弹出
            showLeftMenuview()
            
        }
        else if contentView.frame.origin.x > leftMenuSize.width {       //左边界目录视图移动的位置大于最大值，回弹到最大值
            leftMenuViewShowReboundDampingAnimation()
            
        }

        
    }

    
}

















