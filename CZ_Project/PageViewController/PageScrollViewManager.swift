//
//  PageScrollViewManager.swift
//  SBZorPageScrollViewConroller
//
//  Created by zol on 2017/8/20.
//  Copyright © 2017年 陈卓. All rights reserved.
//

import UIKit

/// 控制PageScrollViewController可修改属性的类
class PageScrollViewManager: NSObject {
    
    /// 当前显示视图坐标
    var currentControllerIndex : Int     = 0
    
    // MARK: 标题属性设置，不设置则为默认值
    /// 标题的字体
    var titleFontSize        : CGFloat  = 15
    
    /// 标题文字颜色,请使用RGB构造方法，直接使用系统的颜色会出问题
    var titleTextColor       : UIColor = UIColor(red: 0, green: 0, blue: 1, alpha: 1)
    
    /// 选中的文字颜色，,请使用RGB构造方法，直接使用系统的颜色会出问题
    var selectTitleTextColor : UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    
    /// 标题之间的间距
    var titlesInterval       : CGFloat = 20.0
    
    /// 第一个标题和标题栏左边的间距
    var titleLeftInterval    : CGFloat = 0.0
    
    /// 第一个标题和标题栏左边的间距
    var titleRightInterval   : CGFloat = 0.0
    
    /// 标题选中时是否加粗
    var titleBigWhenSelected : Bool    = true
    
    // MARK: 进度条属性设置
    /// 进度条颜色
    var progressViewColor      : UIColor = UIColor.orange
    
    /// 进度条宽度
    let ProgressWidth                    = (20.0 / 375.0 * UIScreen.main.bounds.width)
    
    /// 进度条高度
    let ProgressHeight                   = (2.5 / 667.0 * UIScreen.main.bounds.height)
    
    /// 进度条圆角
    let ProgressCR                       = (1.0 / 375.0 * UIScreen.main.bounds.width)
    
    /// 进度条底部间距
    let ProgressBottomInterval : CGFloat = 6.5
}
