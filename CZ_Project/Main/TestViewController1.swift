//
//  TestViewController1.swift
//  CZ_Project
//
//  Created by zol on 2017/7/6.
//  Copyright © 2017年 zol. All rights reserved.
//

import UIKit

class TestViewController1: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "gundam3"
        let imageView = UIImageView(image: UIImage(named: "gundam3"))
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        view.addSubview(imageView)
        tabBarItem.title = "1"
        edgesForExtendedLayout = UIRectEdge()
        navigationController?.navigationBar.isTranslucent = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
