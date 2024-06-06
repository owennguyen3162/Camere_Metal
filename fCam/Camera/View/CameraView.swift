//
//  CameraView.swift
//  fCam
//
//  Created by Muhammad M. Munir on 16/11/23.
//

import SwiftUI

public struct CameraView: UIViewControllerRepresentable {
    @ObservedObject var viewModel: CameraPreviewViewModel
    
    public func makeUIViewController(
        context: Context
    ) -> some UIViewController {
        return CameraController(viewModel: viewModel)
    }
    
    public func updateUIViewController(
        _ uiViewController: UIViewControllerType,
        context: Context
    ) {}
}
