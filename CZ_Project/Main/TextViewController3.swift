//
//  TextViewController3.swift
//  CZ_Project
//
//  Created by zol on 2017/9/26.
//  Copyright © 2017年 zol. All rights reserved.
//

import UIKit

class TextViewController3: UIViewController {

    // MARK: - 私有属性
    
    /// 接受一个图像作为参数并返回 一个新的图像的函数
    typealias Filter = (CIImage) -> (CIImage)
    
    //imageView1
    fileprivate var imageView1 : UIImageView = {
        
        let imageView   = UIImageView()
        imageView.frame = CGRect(x: 12, y: 12, width: 200, height: 200)
        return imageView
        
    }()
    
    //imageView2
    fileprivate var imageView2 : UIImageView = {
        
        let imageView   = UIImageView()
        imageView.frame = CGRect(x: 12, y: 212, width: 200, height: 200)
        return imageView
        
    }()
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "gundam5"
        view.backgroundColor  = UIColor.white
        tabBarItem.title = "3"
        navigationController?.navigationBar.isTranslucent = false
        
        view.addSubview(imageView1)
        view.addSubview(imageView2)
        
        guard let image = UIImage(named: "gundam1.jpg") else {
            fatalError()
        }
        
        guard let cimage = CIImage(image: image) else {
            fatalError()
        }
        
        //高斯模糊滤镜
        let radius       = 100.0
        let blurCIimage  = blur(radius: radius)(cimage)
        imageView1.image = UIImage(ciImage: blurCIimage)
        
        //颜色叠层滤镜
        let color          = UIColor.red.withAlphaComponent(0.2)
        let overlayCIimage = overlay(color: color)(blurCIimage)
        imageView2.image   = UIImage(ciImage: overlayCIimage)
    }
    
    // MARK: - 滤镜
    
    // MARK: 高斯模糊
    func blur(radius: Double) -> Filter {
        
        return { image in
            
            let parameters : [String:Any] = [kCIInputRadiusKey:radius, kCIInputImageKey:image]
            
            guard let filter =  CIFilter(name: "CIGaussianBlur", withInputParameters: parameters) else {
                fatalError()
            }
            
            guard let outputImage = filter.outputImage else {
                fatalError()
            }
            
            return outputImage
        }
        
    }
    
    // MARK: 结合两个滤镜创建颜色叠层滤镜
    func overlay(color: UIColor) -> Filter {
        return { image in
            
            let overlay = self.generate(color: color)(image).cropping(to: image.extent)
            return self.compositeSourceOver(overlay: overlay)(image)
            
        }
    }
    
    // MARK: 生成固定颜色滤镜
    func generate(color: UIColor) -> Filter {
        
        return { _ in
            
            let parameters = [kCIInputColorKey:CIColor(cgColor: color.cgColor)]
            
            guard let filter = CIFilter(name: "CIConstantColorGenerator", withInputParameters: parameters) else {
                fatalError()
            }
            
            guard let outputImage = filter.outputImage else {
                fatalError()
            }
            
            return outputImage
            
        }
        
    }
    
    // MARK: 合成滤镜
    func compositeSourceOver(overlay: CIImage) -> Filter {
        
        return { image in
            
            let parameters = [kCIInputImageKey:overlay, kCIInputBackgroundImageKey:image]
            
            guard let filter = CIFilter(name: "CISourceOverCompositing", withInputParameters: parameters) else {
                fatalError()
            }
            
            guard let outputImage = filter.outputImage else {
                fatalError()
            }
            
            return outputImage
            
        }
        
    }
    

}
