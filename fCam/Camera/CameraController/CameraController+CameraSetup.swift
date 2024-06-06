//
//  CameraController+CameraSetup.swift
//  LoveStatus
//
//  Created by trinhhoa on 21/05/2024.
//


import MetalKit
import AVFoundation

extension CameraController {
    func setupAndStartCaptureSection() {
        func configuration() {
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession = AVCaptureSession()
                self.captureSession.beginConfiguration()
                if self.captureSession.canSetSessionPreset(.hd1920x1080) {
                    self.captureSession.sessionPreset = .hd1920x1080
                } else {
                    self.captureSession.sessionPreset = .photo
                }

                self.captureSession.automaticallyConfiguresCaptureDeviceForWideColor = true
                
                self.setupInputs()
                self.setupOutput()
                
                self.captureSession.commitConfiguration()
                self.captureSession.startRunning()
            }
        }
        
        if captureSession == nil {
            configuration()
        } else if let captureSession, !captureSession.isRunning {
            configuration()
        }
    }
    
    func stopCaptureSession() {
        if self.captureSession.isRunning {
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.stopRunning()
            }
        }
    }
    
    func setupMetal() {
        metalDevice = MTLCreateSystemDefaultDevice()
        
        mtkView.device = metalDevice
        mtkView.isPaused = true
        mtkView.enableSetNeedsDisplay = false
        mtkView.delegate = self
        mtkView.framebufferOnly = false

        metalCommandQueue = metalDevice.makeCommandQueue()
    }
    
    func setupCoreImage() {
        ciContext = CIContext(mtlDevice: metalDevice)
    }
    
    func setupInputs() {
        // get back camera
        if let device = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: .back
        ) {
            backCamera = device
        } else {
            fatalError("back camera not found")
        }
        
        // get front camera
        if let device = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: .front
        ) {
            frontCamera = device
        } else {
            fatalError("front camera not found")
        }
        
        //get audio
        let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)!
        self.audioInput = try! AVCaptureDeviceInput(device: audioDevice)

        if captureSession.canAddInput(self.audioInput!) {
            captureSession.addInput(self.audioInput!)
        }
        
        // create input objects from devices
        guard let bInput = try? AVCaptureDeviceInput(device: backCamera) else {
            fatalError("could not create input device from back camera")
        }
        backInput = bInput
        if !captureSession.canAddInput(bInput) {
            fatalError("could not add back camera input to capture session")
        }
        
        guard let fInput = try? AVCaptureDeviceInput(device: frontCamera) else {
            fatalError("could not create input device from front camera")
        }
        frontInput = fInput
        if !captureSession.canAddInput(fInput) {
            fatalError("could not add front camera input to capture session")
        }
        
        // connect last camera input to session
        if backCameraOn {
            captureSession.addInput(backInput)
        } else {
            captureSession.addInput(frontInput)
        }
        
    }
    
    func setupOutput() {
        videoOutput = AVCaptureVideoDataOutput()
        let videoQueue = DispatchQueue(label: "videoQueue", qos: .userInteractive)
        videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
        
//         audio
        
        self.audioOutput = AVCaptureAudioDataOutput()
        let audioOutputQueue: DispatchQueue = DispatchQueue(label: "audio output queue", attributes: [])
        self.audioOutput.setSampleBufferDelegate(self, queue: audioOutputQueue)
        if(captureSession.canAddOutput(audioOutput)){
            self.captureSession.addOutput(self.audioOutput)
        }
        
        self.audioConnection = self.audioOutput.connection(with: AVMediaType.audio)
        //
        
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        } else {
            fatalError("could not add video output")
        }
        
        videoOutput.connections.first?.videoOrientation = .portrait
        videoOutput.connections.first?.isVideoMirrored = !backCameraOn
    }
    
    func switchCameraInput() {
        captureSession.beginConfiguration()
        
        if backCameraOn {
            captureSession.removeInput(backInput)
            captureSession.addInput(frontInput)
            backCameraOn = false
        } else {
            captureSession.removeInput(frontInput)
            captureSession.addInput(backInput)
            backCameraOn = true
        }
        
        videoOutput.connections.first?.videoOrientation = .portrait
        videoOutput.connections.first?.isVideoMirrored = !backCameraOn
        
        captureSession.commitConfiguration()
    }
}
