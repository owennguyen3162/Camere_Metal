//
//  Processor.swift
//  LoveStatus
//
//  Created by HoaTD on 04/06/2024.
//

import Foundation

import AVFoundation
import CoreImage
import UIKit

class Processor {
    
    func process(image: CIImage, withOverlay overlay: UIImage) -> CIImage {
        let overlayImage = CIImage(cgImage: overlay.resize(toSize: image.extent.width).cgImage!)
        return image.applyingFilter("CISourceOverCompositing", parameters: [
            "inputBackgroundImage": image,
            "inputImage": overlayImage
        ])
    }
    
}
