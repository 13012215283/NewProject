//
//  PageScrollViewController.swift
//  particle
//
//  Created by zol on 2017/8/8.
//  Copyright © 2017年 zol. All rights reserved.
//

import UIKit

/// 状态栏高
let StatusBarH     : CGFloat = UIApplication.shared.statusBarFrame.height

/// 导航栏高
let NavigationBarH : CGFloat = 44.0

/*
 SB卓的PageScrollViewController使用说明:
    继承本类，在重写构造方法
    在重写的构造方法中根据本类的公有属性和方法按需要进行设置
    可在子类重写相应的方法（在公有方法中查找）来监听PageScrollViewController的各种状态和事件
 */

class PageViewControllerInfo: NSObject {
    
    /// 子控制器
    var viewConroller : UIViewController?
    
    /// 标题
    var title         : String = ""
    
    /// 左边按钮数组,设置最好不要超过2个
    var leftButtons               = [UIButton]()
    
    /// 右边按钮数组，最多设置两个
    var rightButtons              = [UIButton]()
    
    /// 视图是否正在显示中
    fileprivate(set) var isShowing : Bool = false
    
    /// 获取标题栏的frame
    ///
    /// - Returns: frame
    fileprivate func getTitleScrollBarFrame() -> CGRect {
        let maxButtonCount = max(leftButtons.count, rightButtons.count)
        
        return  CGRect(x: CGFloat(38 *  maxButtonCount + 8),
                       y: StatusBarH,
                       width: UIScreen.main.bounds.width - CGFloat(2 * (38 * maxButtonCount + 8)),
                       height: NavigationBarH)
    }
    
    
}


class PageScrollViewController: UIViewController {
    
    // MARK: - ****** 公有属性 ******
    
    /// 属性管理类，可以修改该类中的属性自定义UI
    let pageScrollViewManager  : PageScrollViewManager = PageScrollViewManager()
    
    /// 当前显示视图坐标
    private(set) var currentControllerIndex : Int     = 0
    
    /// 新出现显示视图坐标
    private(set) var newControllerIndex     : Int  = 0
    
    /// 标题数组
    private(set) var titles              = [String]()
    
    /// 所有标题按钮
    private(set) var leftRightButtons    = [UIButton]()
    
    /// 控制器数组
    private(set) var viewControllersInfo = [PageViewControllerInfo]()
    
    // MARK: -  ****** 公有方法 ******
    
    /// 添加page子控制器
    ///
    /// - Parameters:
    ///   - viewController: 控制器
    ///   - title: 标题
    ///   - leftButtons: 左边栏按钮群
    ///   - rightButtons: 右边栏按钮群
    func addChildPageViewController(_ viewController : UIViewController, title : String, leftButtons : [UIButton]?, rightButtons : [UIButton]?) {
        
        //创建信息类
        let controllerInfo = PageViewControllerInfo()
        controllerInfo.viewConroller = viewController
        controllerInfo.title         = title
        if let leftButtons = leftButtons {
            controllerInfo.leftButtons = leftButtons
        }
        
        if let rightButtons = rightButtons {
            controllerInfo.rightButtons = rightButtons
        }
        
        //添加标题到标题数组
        titles.append(title)
        
        //添加控制器信息到数组
        viewControllersInfo.append(controllerInfo)
        
    }
    
    // MARK: ****** 留给子类实现的方法 ******
    
    /// 控制器，点击了标题按钮
    ///
    /// - Parameters:
    ///   - button: 按钮
    ///   - index: 坐标
    func pageScrollViewControllerClickedTitle(button : UIButton, index : Int) {
        
        print("点击了第\(index)个标题按钮")
        
    }

    
    /// 控制器，刚开始出现在窗口
    ///
    /// - Parameters:
    ///   - newViewControllerInfo: 视图控制器信息
    ///   - index: 控制器坐标
    func pageScrollViewIsShowing(newViewControllerInfo : PageViewControllerInfo, index : NSInteger) {
        
        print("....新的视图控制器\(index)出现,isShowing:\(newViewControllerInfo.isShowing)")
        
    }
    
    /// 控制器，已经隐藏
    ///
    /// - Parameters:
    ///   - newViewControllerInfo: 视图控制器信息
    ///   - index: 控制器坐标
    func pageScrollViewIsHidden(viewControllerInfo : PageViewControllerInfo, index : NSInteger) {
        
        print("————>控制器已经隐藏\(index),isShowing:\(viewControllerInfo.isShowing)")
        
    }
    
    /// 当前显示的控制器视图发送了变化
    ///
    /// - Parameters:
    ///   - newViewControllerInfo: 新的控制器信息
    ///   - newindex: 新的控制器坐标
    ///   - lastViewControllerInfo: 旧的控制器信息
    ///   - lastindex: 旧的控制器坐标
    func pageScrollViewCurrentViewControllerChange(newViewControllerInfo : PageViewControllerInfo, newindex : NSInteger, lastViewControllerInfo : PageViewControllerInfo, lastindex : NSInteger) {
        
        print("当前控制器已经由\(lastindex),isShowing:\(lastViewControllerInfo.isShowing)。变成\(newindex),isShowing:\(newViewControllerInfo.isShowing)")
        
    }


    
    // MARK: - ****** 私有属性 ******
    
    fileprivate var isAnimation : Bool = false
    
    //上次的x坐标，用于判断方向
    fileprivate var lastContentOffsetX : CGFloat = 0
    
    /// 顶部导航工具栏
    fileprivate lazy var topToolBar    : UIView = {
       
        let topView             = UIView()
        topView.frame           = CGRect(x: 0, y: 0,
                                         width: self.view.frame.width,
                                         height: StatusBarH + NavigationBarH)
        topView.backgroundColor = UIColor.white
        
        topView.addSubview(self.titlesScrollBar)
        topView.addSubview(self.leftCoverView)
        topView.addSubview(self.rightCoverView)
        
        let separateView = UIView()
        separateView.backgroundColor = UIColor.red;
        separateView.frame           = CGRect(x: 0,
                                              y: topView.frame.size.height - 1,
                                              width: topView.frame.width,
                                              height: 1)
        
        topView.addSubview(separateView)
        return topView
        
    }()
    
    /// 页面滚动底视图
    fileprivate lazy var pageScrollView : UIScrollView = {
        
        let scrollView = UIScrollView()
        scrollView.frame                          = CGRect(x: 0,
                                                           y: self.topToolBar.frame.maxY,
                                                           width: self.view.frame.width ,
                                                           height: self.view.frame.height - self.topToolBar.frame.height)
        scrollView.bounces                        = false
        scrollView.showsVerticalScrollIndicator   = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled                = true
        scrollView.delegate                       = self
        
        return scrollView
    }()
    
    /// 标题滚动栏
    fileprivate lazy var titlesScrollBar : TitlesScrollBar = {
        let scrollBar        = TitlesScrollBar(titles: self.titles,
                                               pageScrollViewManager : self.pageScrollViewManager,
                                               frame: CGRect(x: 0, y: StatusBarH, width: self.view.frame.width, height: NavigationBarH));
        scrollBar.backgroundColor  = UIColor.white
        scrollBar.myDelegate = self
        return scrollBar
    }()
    
    /// 左边遮罩层
    lazy var leftCoverView : UIImageView  = {
        
        let letfCoverImage = UIImage(named: "l_r")
        let converView     = UIImageView(image: letfCoverImage)
        converView.frame = CGRect(x: self.titlesScrollBar.frame.minX,
                                  y: self.titlesScrollBar.frame.minY,
                                  width: 5.0,
                                  height: self.titlesScrollBar.frame.height)
        return converView
    }()
    
    /// 右边遮罩层
    lazy var rightCoverView : UIImageView  = {
        
        let rightCoverImage = UIImage(named: "r_l")
        let converView     = UIImageView(image: rightCoverImage)
        converView.frame = CGRect(x: self.titlesScrollBar.frame.maxX - 5.0,
                                  y: self.titlesScrollBar.frame.minY,
                                  width: 5.0,
                                  height: self.titlesScrollBar.frame.height)
        return converView
    }()

    
    // MARK: - ****** 私有方法 ******
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置UI
        setupUI()
    }
    
    // MARK: 设置UI
    fileprivate func setupUI() {
        
        //获取当前需要显示的视图的坐标位置
        currentControllerIndex = pageScrollViewManager.currentControllerIndex
        
        viewControllersInfo[currentControllerIndex].isShowing = true
        
        
        //添加子视图
        view.addSubview(topToolBar)
        view.addSubview(pageScrollView)
        
        //添加所有按钮，并设置标题栏
        addAllButtons()
        
        //添加所有控制器
        addAllControllers()
        
        //滚动到要显示的当前视图
        pageScrollView.setContentOffset(CGPoint(x:view.frame.width * CGFloat(currentControllerIndex), y: 0), animated: false)
    }
    
    /// 添加所有的控制器
    fileprivate func addAllControllers() {
        
        pageScrollView.contentSize = CGSize(width: pageScrollView.frame.width * CGFloat(viewControllersInfo.count),
                                            height: pageScrollView.frame.height);
        
        for index in 0..<viewControllersInfo.count {
            
            let controllerInfo = viewControllersInfo[index]
            
            guard let viewController = controllerInfo.viewConroller else {
                //解包失败，跳过
                continue
            }
            //添加子控制器
            addChildViewController(viewController)
            
            let floatIndex = CGFloat(index)
            
            viewController.view.frame = CGRect(x: floatIndex * pageScrollView.frame.width,
                                               y: 0,
                                               width: pageScrollView.frame.width,
                                               height: pageScrollView.frame.height)
            
            pageScrollView.addSubview(viewController.view)
        }	
        
    }

    
    // MARK: 添加所有滑动栏上的按钮
    fileprivate func addAllButtons() {
        
        for (infoIndex, controllerInfo) in viewControllersInfo.enumerated() {
            
            //添加左边按钮群
            for index in 0..<controllerInfo.leftButtons.count {
                
                let button : UIButton = controllerInfo.leftButtons[index]
                button.frame.size = CGSize(width: 30, height: 30)
                button.center     = CGPoint(x:CGFloat(38 * index + 8 + 15),
                                            y: StatusBarH + titlesScrollBar.frame.height / 2.0)
                button.isHidden   = infoIndex == 0 ? false : true
                button.alpha      = infoIndex == 0 ? 1     : 0
                topToolBar.addSubview(button)
                leftRightButtons.append(button)
                
            }
            
            //添加右边按钮群
            for index in 0..<controllerInfo.rightButtons.count {
                
                let button : UIButton = controllerInfo.rightButtons[index]
                button.frame.size = CGSize(width: 30, height: 30)
                button.center     = CGPoint(x: topToolBar.frame.width - CGFloat(38 * index + 8 + 15),
                                            y: StatusBarH + titlesScrollBar.frame.height / 2.0)
                button.isHidden   = infoIndex == 0 ? false : true
                button.alpha      = infoIndex == 0 ? 1     : 0
                topToolBar.addSubview(button)
                leftRightButtons.append(button)
            }

        }
        
        let currentControllerInfo = viewControllersInfo.first
        titlesScrollBar.frame     = currentControllerInfo?.getTitleScrollBarFrame() ?? CGRect.zero
        
        // 更新遮盖图frame
        updateConverViewFrame()
    }
    
    /// 更新遮盖图frame
    private func updateConverViewFrame() {
        leftCoverView.frame = CGRect(x: self.titlesScrollBar.frame.minX,
                                     y: self.titlesScrollBar.frame.minY,
                                     width: 5.0,
                                     height: self.titlesScrollBar.frame.height)
        rightCoverView.frame =  CGRect(x: self.titlesScrollBar.frame.maxX - 5.0,
                                       y: self.titlesScrollBar.frame.minY,
                                       width: 5.0,
                                       height: self.titlesScrollBar.frame.height)
        
    }

    // MARK: 标题栏自动右滑timer调用方法
    @objc private func functionForRightTimer(timer : Timer) {
        titlesScrollBar.contentOffset.x += 1
        let dic = timer.userInfo as! Dictionary<String, CGPoint>
        let scrollBarContentOffset : CGPoint = dic["scrollBarContentOffset"]!
        if Int(scrollBarContentOffset.x) <= Int(titlesScrollBar.contentOffset.x ) {
            timer.invalidate()
            isAnimation = false
        }
    }
    
    // MARK: 标题栏自动左滑timer调用方法

    @objc private func functionForLeftTimer(timer : Timer) {
        titlesScrollBar.contentOffset.x -= 1
        let dic = timer.userInfo as! Dictionary<String, CGPoint>
        let scrollBarContentOffset : CGPoint = dic["scrollBarContentOffset"]!
        if Int(scrollBarContentOffset.x) >= Int(titlesScrollBar.contentOffset.x ) {
            timer.invalidate()
            isAnimation = false
        }
        
    }
    
    
    // MARK: 页面滚动停止时,处理页面出现或消失
    fileprivate func handleViewControllerLocationScrollEnd(scrollView : UIScrollView) {
        
        //已经消失的视图控制器的坐标
        let lastIndex = currentControllerIndex;
        
        //已经出现的视图控制器坐标
        currentControllerIndex = Int(scrollView.contentOffset.x / view.frame.width)
        
        //已经消失的视图控制器
        let lastViewControllerInfo    = viewControllersInfo[lastIndex]
        
        //已经出现的视图控制器
        let currentViewControllerInfo = viewControllersInfo[currentControllerIndex]

        
        //如果新出现的页面和当前页面不是同一个页面
        if newControllerIndex != currentControllerIndex {
            
            viewControllersInfo[newControllerIndex].isShowing = false
            //调用视图已经消失的方法
            pageScrollViewIsHidden(viewControllerInfo: viewControllersInfo[newControllerIndex], index: newControllerIndex)
        }
        
        //如果坐标一样，跳出
        if lastIndex == currentControllerIndex {
            return
        }
        
        //调用视图已经变化的方法
        lastViewControllerInfo.isShowing = false
        
        pageScrollViewCurrentViewControllerChange(newViewControllerInfo: currentViewControllerInfo, newindex: currentControllerIndex, lastViewControllerInfo: lastViewControllerInfo, lastindex: lastIndex)
        
        //调用视图已经消失的方法
        pageScrollViewIsHidden(viewControllerInfo: lastViewControllerInfo, index: lastIndex)
        
        
    }
    
    // MARK: 页面滚动时,处理页面位置和状态
    fileprivate func handleViewControllerLocationScrolling(scrollView : UIScrollView) {
        
        //新出现的视图控制器坐标
        if view.frame.width * CGFloat(currentControllerIndex) > scrollView.contentOffset.x {
            
            newControllerIndex = currentControllerIndex - 1
            
        }
        else if view.frame.width * CGFloat(currentControllerIndex) < scrollView.contentOffset.x {
            
            newControllerIndex = currentControllerIndex + 1
            
        }
        else {
            return
        }
        
        //新出现的视图控制器
        let newShowingViewConrollerInfo = viewControllersInfo[newControllerIndex]
        
        if newShowingViewConrollerInfo.isShowing == false {
            
            newShowingViewConrollerInfo.isShowing = true
            
            pageScrollViewIsShowing(newViewControllerInfo: newShowingViewConrollerInfo, index: newControllerIndex)
            
        }
        
        
    }

    
    // MARK: - 处理滚动逻辑
    fileprivate func handleUIWhenScrolling(scrollView : UIScrollView) {
        
        let titlesButtons = titlesScrollBar.titleButtons
        let progressView  = titlesScrollBar.progressView
        
        // MARK: 进度条位置处理
        let currentIndex = Int(scrollView.contentOffset.x / view.frame.width)
        let nextIndex    = currentIndex >= titlesButtons.count - 1 ? currentIndex : currentIndex + 1
        
        
        let currentCenterX = titlesButtons[currentIndex].center.x
        let nextCenterX  = titlesButtons[nextIndex].center.x
        let totalInterval = nextCenterX - currentCenterX
        
        progressView.center.x = currentCenterX + (scrollView.contentOffset.x - view.frame.width * CGFloat(currentIndex)) / view.frame.width * totalInterval
        
        // MARK: 处理控制器的按钮渐显和渐隐
        
        let currentControllerInfo = viewControllersInfo[currentIndex]
        let nextControllerInfo    = viewControllersInfo[nextIndex]
        
        //获取控制器的坐边和右边的所有按钮
        let currentButtons        = currentControllerInfo.leftButtons + currentControllerInfo.rightButtons
        let nextButtons           = nextControllerInfo.leftButtons    + nextControllerInfo.rightButtons
        
        //隐藏所有按钮
        for button in leftRightButtons {
            
            button.isHidden = true
            
        }
        
        if currentIndex != nextIndex { //当前页面不是最后的页面
            
            //设置当前的按钮
            for button in currentButtons {
                
                button.isHidden = false
                button.alpha = 1.0 - (scrollView.contentOffset.x - view.frame.width * CGFloat(currentIndex))  / view.frame.width * 1.0
                button.isHidden = button.alpha > 0 ? false : true
            }
            
            //设置下一坨按钮
            for button in nextButtons {
                
                button.isHidden = false
                button.alpha = (scrollView.contentOffset.x - view.frame.width * CGFloat(currentIndex))  / view.frame.width * 1.0
                button.isHidden = button.alpha > 0 ? false : true
                
            }
            
        }
        else { //当前页面到达最后的页面，特殊处理按钮
            
            for button in currentButtons {
                button.isHidden = false
                button.alpha    = 1.0
            }
            
        }
        
        // MARK: 处理标题字体粗细和颜色
        
        //处理字体粗细
        let currentTitleButton      = titlesButtons[currentIndex]
        let nextTitleButton         = titlesButtons[nextIndex]
        let changeOfWeight :CGFloat = 0.3 - 0
        if currentIndex != nextIndex {
            currentTitleButton.titleLabel?.font = UIFont.systemFont(ofSize: pageScrollViewManager.titleFontSize,
                                                                    weight: 0.3 - (scrollView.contentOffset.x - view.frame.width * CGFloat(currentIndex)) / view.frame.width * changeOfWeight)
            nextTitleButton.titleLabel?.font = UIFont.systemFont(ofSize: pageScrollViewManager.titleFontSize,
                                                                 weight: 0 + (scrollView.contentOffset.x - view.frame.width * CGFloat(currentIndex)) / view.frame.width * changeOfWeight)
        }else {
            currentTitleButton.titleLabel?.font = UIFont.systemFont(ofSize: pageScrollViewManager.titleFontSize,
                                                                    weight: 0.3)
        }
        
        //处理字体颜色
        let normalColorComponents = pageScrollViewManager.titleTextColor.cgColor.components
        let selectColorComponents = pageScrollViewManager.selectTitleTextColor.cgColor.components
        
        if normalColorComponents?.count == 4 && selectColorComponents?.count == 4 {
            
            let normalRedValue   : CGFloat! = normalColorComponents?[0]
            let normalGreenValue : CGFloat! = normalColorComponents?[1]
            let normalBlueValue  : CGFloat! = normalColorComponents?[2]
            
            let selectRedValue   : CGFloat! = selectColorComponents?[0]
            let selectGreenValue : CGFloat! = selectColorComponents?[1]
            let selectBlueValue  : CGFloat! = selectColorComponents?[2]
            
            let changeOfRedValue   = selectRedValue - normalRedValue
            let changeOfGreenValue = selectGreenValue - normalGreenValue
            let changeOfBlueValue  = selectBlueValue - normalBlueValue
            
            let currentRedValue   = selectRedValue - (scrollView.contentOffset.x - view.frame.width * CGFloat(currentIndex)) / view.frame.width * changeOfRedValue
            let currentGreenValue = selectGreenValue - (scrollView.contentOffset.x - view.frame.width * CGFloat(currentIndex)) / view.frame.width * changeOfGreenValue
            let currentBlueValue = selectBlueValue - (scrollView.contentOffset.x - view.frame.width * CGFloat(currentIndex)) / view.frame.width * changeOfBlueValue
            let currentTitleColor = UIColor(red: currentRedValue, green: currentGreenValue, blue: currentBlueValue, alpha: 1)
            
            let nextRedValue   = selectRedValue + (scrollView.contentOffset.x - view.frame.width * CGFloat(nextIndex)) / view.frame.width * changeOfRedValue
            let nextGreenValue = selectGreenValue + (scrollView.contentOffset.x - view.frame.width * CGFloat(nextIndex)) / view.frame.width * changeOfGreenValue
            let nextBlueValue = selectBlueValue + (scrollView.contentOffset.x - view.frame.width * CGFloat(nextIndex)) / view.frame.width * changeOfBlueValue
            let nextTitleColor = UIColor(red: nextRedValue, green: nextGreenValue, blue: nextBlueValue, alpha: 1)
            
            currentTitleButton.setTitleColor(currentTitleColor, for: UIControlState.normal)
            nextTitleButton.setTitleColor(nextTitleColor, for: UIControlState.normal)
        }
        
        
        // MARK: 处理标题栏frame变化
        let currentTitleBarFrame = currentControllerInfo.getTitleScrollBarFrame()
        let nextTitleBarFrame    = nextControllerInfo.getTitleScrollBarFrame()
        let changeOfx            = nextTitleBarFrame.minX - currentTitleBarFrame.minX
        let changeOfWidth        = nextTitleBarFrame.width - currentTitleBarFrame.width
        
        titlesScrollBar.frame.origin.x = currentTitleBarFrame.minX + (scrollView.contentOffset.x - view.frame.width * CGFloat(currentIndex)) / view.frame.width * changeOfx
        titlesScrollBar.frame.size.width = currentTitleBarFrame.width + (scrollView.contentOffset.x - view.frame.width * CGFloat(currentIndex)) / view.frame.width * changeOfWidth
        
        // 更新遮盖图frame
        updateConverViewFrame()

        
        // MARK:标题栏滚动右滑位置处理
        if progressView.frame.maxX > titlesButtons[currentIndex].frame.maxX && scrollView.contentOffset.x > lastContentOffsetX
            && (titlesScrollBar.contentOffset.x + titlesScrollBar.frame.width) < titlesButtons[nextIndex].frame.maxX
        {
            
            //开启定时器，移动title
            if isAnimation == false {
                
                let scrollBarContentOffset = CGPoint(x: titlesButtons[nextIndex].frame.maxX - titlesScrollBar.frame.width,
                                                     y: 0)
                //MARK: 由于使用系统的滚动动画的timer不是加在RunLoop的commonModes上,page滚动时会使动画停止。所以在这里用timer自己做动画
                
                //保护，防止在不需要的时候再次添加timer（我™也不知道有没有用）
                if Int(scrollBarContentOffset.x) <= Int(titlesScrollBar.contentOffset.x) {
                    return
                }
                
                isAnimation = true
                var timer : Timer?
                timer = Timer.init(timeInterval: 0.002,
                                   target: self,
                                   selector: #selector(functionForRightTimer(timer:)),
                                   userInfo: ["scrollBarContentOffset":scrollBarContentOffset],
                                   repeats: true)
                
                RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
            }
            
        }
        
        //标题栏滚动左滑位置处理
        if progressView.frame.minX < titlesButtons[nextIndex].frame.minX && scrollView.contentOffset.x < lastContentOffsetX
            && titlesButtons[currentIndex].frame.minX < titlesScrollBar.contentOffset.x
        {
            
            //开启定时器，移动title
            if isAnimation == false {
                
                let scrollBarContentOffset = CGPoint(x: titlesButtons[currentIndex].frame.minX,
                                                     y: 0)
                
                //保护，防止在不需要的时候再次添加timer（我™也不知道有没有用）
                if Int(scrollBarContentOffset.x) >= Int(titlesScrollBar.contentOffset.x) {
                    return
                }
                
                isAnimation = true
                var timer : Timer?
                timer = Timer.init(timeInterval: 0.002,
                                   target: self,
                                   selector: #selector(functionForLeftTimer(timer:)),
                                   userInfo: ["scrollBarContentOffset":scrollBarContentOffset],
                                   repeats: true)
                
                RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
            }
            
        }
        
        //记录本次滚动的x坐标，用于下次判断方向
        lastContentOffsetX = scrollView.contentOffset.x
        
    }
    
}
// MARK: - UIScrollViewDelegate
extension PageScrollViewController : UIScrollViewDelegate {
    
    /// 正在滚动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //滚动时处理UI
        handleUIWhenScrolling(scrollView: scrollView)
        
        //正在滚动时，处理页面的位置
        handleViewControllerLocationScrolling(scrollView: scrollView)
        
    }
    
    /// 滚动停止
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        //处理页面的位置
        handleViewControllerLocationScrollEnd(scrollView: scrollView)

    }
    

    /// 滚动动画停止
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        //处理页面的位置
        handleViewControllerLocationScrollEnd(scrollView: scrollView)

    }
    
}

// MARK: - TitlesScrollBarDelegate
extension PageScrollViewController : TitlesScrollBarDelegate {
    
    func titlesScrollViewClickedTitle(button: UIButton, index: Int) {
        
        pageScrollView.setContentOffset(CGPoint(x: view.frame.size.width * CGFloat(index), y: 0), animated: true)
        
        //调用点击标题按钮的方法
        pageScrollViewControllerClickedTitle(button: button, index: index)
    }
    
}















