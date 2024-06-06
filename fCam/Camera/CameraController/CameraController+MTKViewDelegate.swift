//
//  CameraController+MTKViewDelegate.swift
//  LoveStatus
//
//  Created by trinhhoa on 21/05/2024.
//


import MetalKit

extension CameraController: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    
    func draw(in view: MTKView) {
        guard let commandBuffer = metalCommandQueue.makeCommandBuffer(),
              let ciImage = currentCIImage,
              let currentDrawable = view.currentDrawable
        else { return }
        
        let xPosition = {
            let diff = view.drawableSize.width - ciImage.extent.width
            return diff / 2
        }()
        let yPosition = (view.drawableSize.height - ciImage.extent.height) * 0.5
        let origin = CGPoint(x: -xPosition, y: -yPosition)
        
        self.ciContext.render(
            ciImage,
            to: currentDrawable.texture,
            commandBuffer: commandBuffer,
            bounds: CGRect(origin: origin, size: view.drawableSize),
            colorSpace: CGColorSpaceCreateDeviceRGB()
        )

        commandBuffer.present(currentDrawable)
        commandBuffer.commit()
    }
}
