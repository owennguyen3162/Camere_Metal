//
//  CameraPreviewViewModelInterface.swift
//  fCam
//
//  Created by Muhammad M. Munir on 18/11/23.
//

import CoreImage
import UIKit

public protocol CameraPreviewViewModelInterface {
    var action: CameraActionable? { get set }
    func actionCapturedImage(_ ciImage: CIImage)
    func actionForceStopRecording()
}

public protocol CameraActionable {
    func actionRecording(isRecording: Bool, shouldPlay: Bool)
    func actionOpenPlayer()
    func actionSwitchCamera()
    func actionRGBFilter(color: UIColor)
}
