//
//  CameraPreviewScreen.swift
//  fCam
//
//  Created by Muhammad M. Munir on 18/11/23.
//

import SwiftUI

struct CameraPreviewScreen: View {
    @Environment(\.scenePhase) var scenePhase
    @StateObject private var viewModel = CameraPreviewViewModel()
    
    var body: some View {
        buildContentView()
            .ignoresSafeArea()
            .onAppear(perform: viewModel.checkPermission)
            .onReceive(viewModel.$selectedFilterColor) { _ in
                viewModel.actionRGBFilter()
            }
    }
    
    @ViewBuilder
    private func buildContentView() -> some View {
        #if targetEnvironment(simulator)
        Text("Simulator doesn't have camera device")
        #else
        if viewModel.showCamera {
            buildCameraView()
        } else {
            Text("Please allow access to show camera filter")
        }
        #endif
    }
    
    @ViewBuilder
    private func buildCameraView() -> some View {
        ZStack(alignment: .bottom) {
            CameraView(viewModel: viewModel)
            VStack(spacing: 16) {
//                RGBButtonView(selectedColor: $viewModel.selectedFilterColor)
                buildCameraButtonsView()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
    }
    
    @ViewBuilder
    private func buildCameraButtonsView() -> some View {
        HStack {
            Button(action: viewModel.actionOpenPlayer) {
                CapturedImageView(uiImage: $viewModel.capturedImage)
                    .frame(width: 50, height: 50)
                    .background(Color.clear)
            }
            
            Color.clear.frame(height: 1)
            
            RecordingButton(
                isRecording: $viewModel.isRecording,
                action: viewModel.actionRecording
            )
            
            Color.clear.frame(height: 1)
            
            Button(action: viewModel.actionSwitchCamera) {
                Image(systemName: "arrow.triangle.2.circlepath.camera.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    CameraPreviewScreen()
}
