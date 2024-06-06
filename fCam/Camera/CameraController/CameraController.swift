//
//  CameraView.swift
//  fCam
//
//  Created by Muhammad M. Munir on 16/11/23.
//

import AVFoundation
import AVKit
import MetalKit
import UIKit

final class CameraController: UIViewController {
    let mtkView = MTKView()
    
    var backCamera: AVCaptureDevice!
    var frontCamera: AVCaptureDevice!
    var backInput: AVCaptureInput!
    var frontInput: AVCaptureInput!
    
    var captureSession: AVCaptureSession!
    let drawingCanvas = DrawingCanvas()
    var metalDevice: MTLDevice!
    var metalCommandQueue: MTLCommandQueue!
    
    var ciContext: CIContext!
    var currentCIImage: CIImage?
    
    var videoOutput: AVCaptureVideoDataOutput!
    let processor = Processor()
    let videoWriter = VideoWriter()
    
    var audioInput: AVCaptureDeviceInput!
    var audioOutput: AVCaptureAudioDataOutput = AVCaptureAudioDataOutput()
    var audioConnection: AVCaptureConnection!
    
    let colorFilter = ColorFilter()
    var currentVideoURL: URL?
    var takePicture = false
    var backCameraOn = true
    var isRecording = false
    var selectedColorFilter: UIColor = .clear
    
    var viewModel: CameraPreviewViewModelInterface
    
    init(viewModel: CameraPreviewViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.action = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupMetal()
        setupCoreImage()
        setupAndStartCaptureSection()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopCaptureSession()
    }
    
    private func setupView() {
        view.backgroundColor = .green
        mtkView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mtkView)
        
        NSLayoutConstraint.activate([
            mtkView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor),
            mtkView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            mtkView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            mtkView.topAnchor.constraint(
                equalTo: view.topAnchor)
        ])
        
        drawingCanvas.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(drawingCanvas)
        drawingCanvas.backgroundColor = UIColor.clear
        
        NSLayoutConstraint.activate([
            drawingCanvas.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            drawingCanvas.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            drawingCanvas.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            drawingCanvas.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
    }
    
    func startRecording() {
        let url = FileManagerService.shared.createFileURL("videofilter.mp4")
        FileManagerService.shared.removeFileURL(url)
        videoWriter.startWriting(url)
    }
    
    func stopRecording(shouldPlay: Bool = true) {
        guard !isRecording else { return }

        if let currentCIImage, takePicture {
            takePicture = false
            viewModel.actionCapturedImage(currentCIImage)
        }

        videoWriter.stopWriting { [weak self] url in
            self?.currentVideoURL = url
            
            if shouldPlay {
                DispatchQueue.main.async {
                    self?.playVideo(url: url)
                }
            }
        }
    }
    
    func playVideo(url: URL) {
        let player = AVPlayer(url: url)
        let vc = AVPlayerViewController()
        vc.videoGravity = AVLayerVideoGravity.resizeAspectFill
        vc.player = player
        present(vc, animated: true) {
            vc.player?.play()
        }
    }
}
