//
//  UIImage.swift
//  AVPlayerDemo
//
//  Created by 胡聪 on 2019/1/28.
//  Copyright © 2019 胡聪. All rights reserved.
//

import UIKit

extension UIImage {
    func image(with cornerRadius: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale);
        let context = UIGraphicsGetCurrentContext()
        let rect = CGRect(origin: CGPoint.zero, size: self.size)
        context?.addPath(UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath)
        context?.clip()
        self.draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
}
