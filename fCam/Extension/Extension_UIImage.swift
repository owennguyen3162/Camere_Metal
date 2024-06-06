//
//  UIImageExtension.swift
//  LoveStatus
//
//  Created by HoaTD on 04/06/2024.
//

import UIKit

extension UIImage {
    
    func resize(toSize newWidth: CGFloat) -> UIImage {
        let scale = newWidth / size.width
        let newHeight = size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: 1080, height: 1920))
        draw(in: CGRect(x: 0, y: 0, width: 1080, height: 1920))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
