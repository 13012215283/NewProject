//
//  TitlesScrollBar.swift
//  particle
//
//  Created by zol on 2017/8/9.
//  Copyright © 2017年 zol. All rights reserved.
//

import UIKit

protocol TitlesScrollBarDelegate : NSObjectProtocol {
    
    /// 标题栏点击了标题
    ///
    /// - Parameters:
    ///   - button: 标题按钮
    ///   - index:  标题坐标
    func titlesScrollViewClickedTitle(button : UIButton, index : Int)
    
}


class TitlesScrollBar: UIScrollView {
    // MARK: - ****** 公有属性 ******
    
    /// 自己代理
    weak var myDelegate        : TitlesScrollBarDelegate?
    
    /// UI管理类
    var pageScrollViewManager  : PageScrollViewManager!
    
    /// 标题数组
    var titles                  = [String]()
    
    /// 标题按钮数组
    var titleButtons            = [UIButton]()
    
    /// 所有标题长度的数组
    var titlesWidth             = [CGFloat]()
    
    /// 进度条
    lazy var progressView : UIView = {
       
        
        let progress = UIView()
        progress.backgroundColor     = self.pageScrollViewManager.progressViewColor
        progress.layer.cornerRadius  = self.pageScrollViewManager.ProgressCR
        progress.layer.masksToBounds = true
        return progress
        
    }()
    
    // MARK: - ****** 私有方法 ******
    
    // MARK: 构造方法
    convenience init(titles : [String],pageScrollViewManager : PageScrollViewManager, frame : CGRect) {
        
        self.init(frame: frame)
        showsVerticalScrollIndicator   = false
        showsHorizontalScrollIndicator = false
        delegate = self as UIScrollViewDelegate
        self.pageScrollViewManager = pageScrollViewManager
        self.titles                = titles
        
        //设置子控件
        setupUI()
        
    }
    
    // MARK: 设置UI
    fileprivate func setupUI() {
        
        backgroundColor = UIColor.white
        
        var contentWidth : CGFloat = 0
        
        for index in 0..<titles.count {
            
            let title = titles[index]
            //设置标题长度
            let titleWidth  = textWidth(text: title, font: UIFont.systemFont(ofSize: pageScrollViewManager.titleFontSize))
            titlesWidth.append(titleWidth)
            
            //创建标题按钮
            let titleButton              = UIButton()
            titleButton.tag              = index
            titleButton.titleLabel?.font = UIFont.systemFont(ofSize: pageScrollViewManager.titleFontSize,
                                                             weight: (pageScrollViewManager.titleBigWhenSelected == true && index == pageScrollViewManager.currentControllerIndex) ? 0.3 : 0)
            //设置标题
            titleButton.setTitle(title, for: UIControlState.normal)
            
            //设置标题颜色
            let titleTextColor = index == pageScrollViewManager.currentControllerIndex ? pageScrollViewManager.selectTitleTextColor : pageScrollViewManager.titleTextColor
            titleButton.setTitleColor(titleTextColor, for: UIControlState.normal)
            
            titleButton.addTarget(self, action: #selector(clickedTitleButton(sender:)), for: UIControlEvents.touchUpInside)
            titleButtons.append(titleButton)
            
            //设置button的Frame
            if index == 0 {
                
                titleButton.frame = CGRect(x: pageScrollViewManager.titleLeftInterval, y: 0, width: titleWidth, height: frame.height)
                
            }
            else {
                
                let lastButton    = titleButtons[index - 1]
                titleButton.frame = CGRect(x: lastButton.frame.maxX + pageScrollViewManager.titlesInterval,
                                           y: 0,
                                           width: titleWidth,
                                           height: frame.height)
                
            }
            
            addSubview(titleButton)
            
            contentWidth += titleWidth
            
        }
        
        //设置滚动进度条
        let firstTitleButton = titleButtons.first
        progressView.frame = CGRect(x: 0, y: 0, width: pageScrollViewManager.ProgressWidth, height:pageScrollViewManager.ProgressHeight)
        progressView.center = CGPoint(x: firstTitleButton?.center.x ?? 0,
                                      y: self.frame.height - pageScrollViewManager.ProgressBottomInterval - progressView.frame.height / 2.0)
        addSubview(progressView)
        
        //设置滚动内容size
        contentWidth += pageScrollViewManager.titlesInterval * CGFloat(titles.count - 1) + pageScrollViewManager.titleRightInterval + pageScrollViewManager.titleLeftInterval
        contentSize = CGSize(width: contentWidth, height: frame.height)
        
        
        
    }
    
    // MARK: 标题按钮触发事件
    @objc fileprivate func clickedTitleButton(sender : UIButton) {
        
        myDelegate?.titlesScrollViewClickedTitle(button: sender, index: sender.tag)
        
    }
    
    // MARK: 获取文本宽度
    /// 获取文本宽度
    ///
    /// - Parameters:
    ///   - text: 文本
    ///   - font: 文本字体
    /// - Returns: 宽度
    fileprivate func textWidth(text : String, font : UIFont) -> CGFloat {
        
        let dic = NSMutableDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        let nsText : NSString = text as NSString
        
        let textSize = nsText.boundingRect(with: CGSize(width: Double(MAXFLOAT), height: 0.0), options: .usesLineFragmentOrigin, attributes: dic as? [String : Any], context: nil)
        return textSize.width + 2.0
        
    }
   
}

// MARK: - UIScrollViewDelegate
extension TitlesScrollBar : UIScrollViewDelegate {
    
    // MARK: 滚动逻辑处理
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        
    }
    
    
}

















