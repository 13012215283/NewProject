//
//  MainNavigationViewController.swift
//  CZ_Project
//
//  Created by zol on 2017/6/30.
//  Copyright © 2017年 zol. All rights reserved.
//

import UIKit

class MainNavigationViewController: UINavigationController {
    
    lazy var testVC1 : TestViewController1 = {
        let vc = TestViewController1()
        return vc
    }()
    
    lazy var testVC2 : TextViewController2 = {
        let vc = TextViewController2()
        return vc
    }()
    
    lazy var testVC3 : TextViewController3 = {
        let vc = TextViewController3()
        return vc
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blue
        addChildViewController(testVC1)
        addChildViewController(testVC2)
        addChildViewController(testVC3)
        setViewControllers([testVC1], animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func showTestVC1() {
        setViewControllers([testVC1], animated: false)
        print(viewControllers.count)
      
    }
    
    func showTestVC2() {
        setViewControllers([testVC2], animated: false)
         print(viewControllers.count)
    }
    
    func showTestVC3() {
        setViewControllers([testVC3], animated: false)
        print(viewControllers.count)
        
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
