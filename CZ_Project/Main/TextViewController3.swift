//
//  TextViewController3.swift
//  CZ_Project
//
//  Created by zol on 2017/9/26.
//  Copyright © 2017年 zol. All rights reserved.
//

import UIKit

class TextViewController3: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "gundam5"
        view.backgroundColor  = UIColor.blue
        let imageView         = UIImageView(image: UIImage(named: "gundam5"))
        imageView.frame       = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
        tabBarItem.title = "3"
        edgesForExtendedLayout = UIRectEdge()
        navigationController?.navigationBar.isTranslucent = false
    }

}
