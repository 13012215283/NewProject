//
//  RightMenuViewController.swift
//  CZ_Project
//
//  Created by zol on 2017/6/27.
//  Copyright © 2017年 zol. All rights reserved.
//

import UIKit

class RightMenuViewController: UIViewController {

    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.blue
        view.backgroundColor = UIColor.white
        let imageView = UIImageView(image: UIImage(named: "gandam3"))
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        view.addSubview(imageView)

    }
   
}
