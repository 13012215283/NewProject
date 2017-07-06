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
        let imageView = UIImageView(image: UIImage(named: "gundam1"))
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        view.addSubview(imageView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        cz_delegate?.changeContentViewController(withIndex: index == 1 ? 2 : 1)
        
    }
  
}
