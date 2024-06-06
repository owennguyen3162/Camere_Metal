//
//  CameraController+CaptureOutput.swift
//  fCam
//
//  Created by Muhammad M. Munir on 18/11/23.
//

import AVFoundation
import CoreImage
import UIKit
import MetalKit


extension CameraController: AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate
{
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        if(videoOutput.connections.first == connection) {
            
            guard let cvBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
            var ciImage = CIImage(cvImageBuffer: cvBuffer)
            
            let scaledCIImage = scaleImageToFitScreen(ciImage, in: mtkView)
            currentCIImage = scaledCIImage
            
            // draw to camera preview
            mtkView.draw()
            
            
            if let buffer = self.drawingCanvas.getImagePlayerBuffer() {

                        ciImage = self.processor.process(image: ciImage, withOverlay: buffer)
                
                }
            
            
           
            if let buffer = self.drawingCanvas.getImagePlayerBuffer1() {
             
                        ciImage = self.processor.process(image: ciImage, withOverlay: buffer)
                   
            }
            
       
            
          
            if let buffer = self.drawingCanvas.getImageBuffer() {
                ciImage = self.processor.process(image: ciImage, withOverlay: buffer)
            }
            
            
            // writing to file
            if isRecording {
                let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
                let time = CMSampleBufferGetOutputPresentationTimeStamp(sampleBuffer)
                ciContext.render(ciImage, to: pixelBuffer)
                
                DispatchQueue.main.async {
                    self.videoWriter.appendPixelBuffer(pixelBuffer: pixelBuffer, time: time)
                }
            }
        } else if audioConnection == connection {
            
            if isRecording {
                DispatchQueue.main.async {
                    self.videoWriter.appendAudioBuffer(sampleBuffer)
                }
            }
        }
    }
}

private func scaleImageToFitScreen(_ ciImage: CIImage, in view: MTKView) -> CIImage {
    
    let targetSize = view.drawableSize
    let scaleX = targetSize.width / ciImage.extent.width
    let scaleY = targetSize.height / ciImage.extent.height
    let scale = max(scaleX, scaleY)
    
    let transform = CGAffineTransform(scaleX: scale, y: scale)
    return ciImage.transformed(by: transform)
}
