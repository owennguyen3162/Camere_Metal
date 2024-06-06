//
//  ColorFilter.swift
//  fCam
//
//  Created by Muhammad M. Munir on 18/11/23.
//

import CoreImage
import UIKit

struct ColorFilter {
    private func createOverlay(_ color: UIColor) -> CIImage {
        let overlayColor = color.withAlphaComponent(0.2)
        let c = CIColor(color: overlayColor)
        let parameters = [kCIInputColorKey: c]
        let filter = CIFilter(name: "CIConstantColorGenerator", parameters: parameters)!
        return filter.outputImage!
    }
    
    func process(image: CIImage, color: UIColor) -> CIImage! {
        let filter = CIFilter(
            name: "CISourceOverCompositing",
            parameters: [
                kCIInputBackgroundImageKey: image,
                kCIInputImageKey: createOverlay(color)
            ]
        )!
        return filter.outputImage!.cropped(to: image.extent)
    }
}
