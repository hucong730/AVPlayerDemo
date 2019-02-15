//
//  UIColor.swift
//  AVPlayerDemo
//
//  Created by 胡聪 on 2019/1/28.
//  Copyright © 2019 胡聪. All rights reserved.
//

import UIKit

extension UIColor {
    
    func createImage(size : CGSize) -> UIImage? {
        let rect = CGRect(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
