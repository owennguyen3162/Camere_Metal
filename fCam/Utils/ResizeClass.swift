//
//  Resize.swift
//  LTVideoRecorder
//
//  Created by Nguyễn Linh on 05/06/2024.
//  Copyright © 2024 ltebean. All rights reserved.
//

import UIKit

class ResizeClass {
    
    static let shared = ResizeClass()
    
    init() {}
    
    func pixelPerfect (forWidth widthS: Int, forHeight heightS: Int) -> CGSize {
        let iPhone13MiniSize = CGSize(width: 375, height: 812)
        let currentScreenSize = UIScreen.main.bounds.size

        let originalSize = CGSize(width: widthS - 15, height: heightS - 15)
        let adjustedSize = originalSize.adjusted(for: iPhone13MiniSize, relativeTo: currentScreenSize)
        
        return adjustedSize
    }
}
