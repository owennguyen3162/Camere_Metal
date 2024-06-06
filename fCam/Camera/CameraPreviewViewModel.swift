//
//  CameraPreviewViewModel.swift
//  fCam
//
//  Created by Muhammad M. Munir on 18/11/23.
//

import AVFoundation
import SwiftUI

final class CameraPreviewViewModel: ObservableObject {
    @Published public var showCamera = false
    @Published public var isRecording = false
    @Published public var selectedFilterColor: Color = .clear
    @Published public var capturedImage: UIImage?
    
    var action: CameraActionable?
    
    public func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            showCamera = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] authorized in
                Task { @MainActor [weak self] in
                    self?.showCamera = authorized
                }
            }
        default:
            showCamera = false
        }
    }
    
    public func actionRecording() {
        action?.actionRecording(isRecording: isRecording, shouldPlay: true)
    }
    
    public func actionOpenPlayer() {
        action?.actionOpenPlayer()
    }
    
    public func actionSwitchCamera() {
        action?.actionSwitchCamera()
    }
    
    public func actionRGBFilter() {
        action?.actionRGBFilter(color: UIColor(selectedFilterColor))
    }
}

extension CameraPreviewViewModel: CameraPreviewViewModelInterface {
    func actionCapturedImage(_ ciImage: CIImage) {
        Task { @MainActor [weak self] in
            let uiImage = UIImage(ciImage: ciImage)
            self?.capturedImage = uiImage
        }
    }
    
    func actionForceStopRecording() {
        isRecording = false
        action?.actionRecording(isRecording: isRecording, shouldPlay: false)
    }
}
