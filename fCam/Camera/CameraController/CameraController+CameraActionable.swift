//
//  CameraController+CameraActionable.swift
//  fCam
//
//  Created by Muhammad M. Munir on 18/11/23.
//

import UIKit

extension CameraController: CameraActionable {
    func actionRecording(isRecording: Bool, shouldPlay: Bool) {
        self.isRecording = isRecording
        if isRecording {
            takePicture = true
            startRecording()
        } else {
            stopRecording(shouldPlay: shouldPlay)
        }
    }
    
    func actionOpenPlayer() {
        guard let currentVideoURL else { return }
        playVideo(url: currentVideoURL)
    }
    
    func actionSwitchCamera() {
        switchCameraInput()
    }
    
    func actionRGBFilter(color: UIColor) {
        selectedColorFilter = color
    }
}
