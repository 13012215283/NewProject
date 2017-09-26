//
//  LeftMemuViewController.swift
//  CZ_Project
//
//  Created by zol on 2017/6/27.
//  Copyright © 2017年 zol. All rights reserved.
//

import UIKit

protocol LeftMemuViewControllerDelegate {
    
    func changeContentViewController(withIndex index : NSInteger)
    
}

class LeftMemuViewController: UIViewController {
    
    /// 代理
    var cz_delegate : LeftMemuViewControllerDelegate?
    var index = 1
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        index = 1
        view.backgroundColor = UIColor.white
        let imageView   = UIImageView(image: UIImage(named: "gundam1"))
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.addSubview(imageView)
        addTestButtons()
    }
    
    //添加测试用按钮
    private func addTestButtons() {
        
        for index in 0..<3 {
            
            let button = UIButton()
            button.backgroundColor = UIColor.black
            button.frame = CGRect(x: view.frame.maxX - leftMenuSize.width + CZ_Interval,
                                  y: 64 + (CZ_Interval + 80) * CGFloat(index) ,
                                  width: leftMenuSize.width / 2.0,
                                  height: 80)
            button.tag   = index
            button.layer.shadowOpacity = 0.6
            button.layer.shadowRadius  = 3
            button.layer.shadowColor   = UIColor.black.cgColor
            button.setTitle("gundam\(index + 3)", for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            view.addSubview(button)
            
            button.addTarget(self, action: #selector(actionForTestButton(sender:)), for: .touchUpInside)
        }
        
    }
    
    // MARK: - 控件方法
    @objc private func actionForTestButton(sender: UIButton) {
         cz_delegate?.changeContentViewController(withIndex: sender.tag)
    }
    
}
