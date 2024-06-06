//
//  Extension.swift
//  LTVideoRecorder
//
//  Created by Nguyễn Linh on 05/06/2024.
//  Copyright © 2024 ltebean. All rights reserved.
//

import UIKit

extension CGFloat {
    func adjusted(for baseSize: CGFloat, relativeTo screenSize: CGFloat) -> CGFloat {
        return self * (screenSize / baseSize)
    }
}

extension CGSize {
    func adjusted(for baseSize: CGSize, relativeTo screenSize: CGSize) -> CGSize {
        let widthRatio = screenSize.width / baseSize.width
        let heightRatio = screenSize.height / baseSize.height
        return CGSize(width: self.width * widthRatio, height: self.height * heightRatio)
    }
}
