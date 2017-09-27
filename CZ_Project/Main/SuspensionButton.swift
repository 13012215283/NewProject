//
//  SuspensionButton.swift
//  CZ_Project
//
//  Created by zol on 2017/9/26.
//  Copyright © 2017年 zol. All rights reserved.
//

import UIKit

class SuspensionButton: UIButton {
    
    // MARK: - 公有属性
    /// 动画视图
    lazy var animationImageView : UIImageView = {
       
        let imageView   = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        return imageView
        
    }()
    
    /// 拖动手势
    lazy var moveReconizer : UIPanGestureRecognizer = {
       
        let moveReconier = UIPanGestureRecognizer(target: self, action: #selector(actionForPanGesture(reconizer:)))
        return moveReconier
        
    }()
    
    // MARK: - 构造方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(actionForButton(sender:)), for: .touchUpInside)
        addSubview(animationImageView)
        addGestureRecognizer(moveReconizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    // MARK: - 私有方法
    
    // MARK: 点击按钮
    @objc private func actionForButton(sender: UIButton) {
        
    }
    
    // MARK: 拖动手势
    @objc private func actionForPanGesture(reconizer: UIPanGestureRecognizer) {
        
    }
    
}
