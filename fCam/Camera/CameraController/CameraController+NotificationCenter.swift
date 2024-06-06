//
//  CameraController+NotificationCenter.swift
//  fCam
//
//  Created by Muhammad M. Munir on 18/11/23.
//

import UIKit

extension CameraController {
    func setupNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self, selector: #selector(appMovedToBackground),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
        notificationCenter.addObserver(
            self, selector: #selector(appMovedToForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    @objc
    private func appMovedToBackground() {
        viewModel.actionForceStopRecording()
        stopCaptureSession()
    }
    
    @objc
    private func appMovedToForeground() {
        setupAndStartCaptureSection()
    }
}
