//
//  QRScannerView.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 10/03/25.
//

//
//import UIKit
//import AVFoundation
//
//class QRScannerView: UIView, AVCaptureMetadataOutputObjectsDelegate {
//    
//    private var captureSession: AVCaptureSession?
//    private var previewLayer: AVCaptureVideoPreviewLayer?
//    
//    var onQRCodeScanned: ((String) -> Void)?
//    
//    /// 🔴 Flag to control camera usage
//    var shouldEnableCamera: Bool = false {
//        didSet {
//            if shouldEnableCamera {
//                setupScanner()      // start only when true
//            } else {
//                turnOffCamera()     // stop & release when false
//            }
//        }
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        // ⚠️ Don't start camera here
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        // ⚠️ Don't start camera here
//    }
//    
//    // MARK: - Camera Setup
//    private func setupScanner() {
//        // Prevent multiple sessions
//        guard captureSession == nil else { return }
//        
//        captureSession = AVCaptureSession()
//        
//        guard let videoCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
//            print("Failed to access camera")
//            return
//        }
//        
//        do {
//            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
//            if captureSession!.canAddInput(videoInput) {
//                captureSession!.addInput(videoInput)
//            }
//        } catch {
//            print("Error setting up video input: \(error)")
//            return
//        }
//        
//        let metadataOutput = AVCaptureMetadataOutput()
//        if captureSession!.canAddOutput(metadataOutput) {
//            captureSession!.addOutput(metadataOutput)
//            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//            metadataOutput.metadataObjectTypes = [.qr]
//        }
//        
//        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
//        previewLayer?.videoGravity = .resizeAspectFill
//        previewLayer?.frame = self.layer.bounds
//        self.layer.addSublayer(previewLayer!)
//        
//        DispatchQueue.main.async { [weak self] in
//            self?.captureSession?.startRunning()
//        }
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        previewLayer?.frame = self.bounds
//    }
//    
//    func metadataOutput(_ output: AVCaptureMetadataOutput,
//                        didOutput metadataObjects: [AVMetadataObject],
//                        from connection: AVCaptureConnection) {
//        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
//              let scannedString = metadataObject.stringValue else { return }
//        
//        onQRCodeScanned?(scannedString)
//        captureSession?.stopRunning()
//    }
//    
//    func startScanning() {
//        if !(captureSession?.isRunning ?? false) {
//            DispatchQueue.global(qos: .userInitiated).async {
//                self.captureSession?.startRunning()
//            }
//        }
//    }
//    
//    func stopScanning() {
//        if captureSession?.isRunning ?? false {
//            captureSession?.stopRunning()
//        }
//    }
//    
//    // MARK: - 🔴 Fully turn off & release camera
//    func turnOffCamera() {
//        if captureSession?.isRunning ?? false {
//            captureSession?.stopRunning()
//        }
//        
//        captureSession?.inputs.forEach { captureSession?.removeInput($0) }
//        captureSession?.outputs.forEach { captureSession?.removeOutput($0) }
//        
//        previewLayer?.removeFromSuperlayer()
//        previewLayer = nil
//        captureSession = nil
//    }
//}



import UIKit
import AVFoundation

class QRScannerView: UIView, AVCaptureMetadataOutputObjectsDelegate {
    
    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    var onQRCodeScanned: ((String) -> Void)?
    
    /// 🔴 Flag to control camera usage
    var shouldEnableCamera: Bool = false {
        didSet {
            if shouldEnableCamera {
                checkCameraPermissionAndSetup()
            } else {
                turnOffCamera()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Camera Permission + Setup
    private func checkCameraPermissionAndSetup() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            // Already authorized → setup scanner
            setupScanner()
        case .notDetermined:
            // First time → request
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.setupScanner()
                    } else {
                        self?.showPermissionAlert()
                    }
                }
            }
        case .denied, .restricted:
            // Denied earlier → show alert to go to Settings
            showPermissionAlert()
        @unknown default:
            break
        }
    }
    
    private func showPermissionAlert() {
        guard let topController = UIApplication.shared.keyWindow?.rootViewController else { return }
        
        let alert = UIAlertController(
            title: "Camera Permission Needed",
            message: "Please allow camera access in Settings to scan QR codes.",
            preferredStyle: .alert
        )
        
        // ⬅️ Cancel button: dismiss / go back
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
//            if let nav = topController as? UINavigationController {
//                nav.popViewController(animated: true)   // if inside navigation stack
//            } else {
//                topController.dismiss(animated: true)   // if presented modally
//            }
//        })
        
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        })
        
        topController.present(alert, animated: true, completion: nil)
    }

    
    // MARK: - Camera Setup
    private func setupScanner() {
        // Prevent multiple sessions
        guard captureSession == nil else { return }
        
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Failed to access camera")
            return
        }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            if captureSession!.canAddInput(videoInput) {
                captureSession!.addInput(videoInput)
            }
        } catch {
            print("Error setting up video input: \(error)")
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        if captureSession!.canAddOutput(metadataOutput) {
            captureSession!.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = self.layer.bounds
        self.layer.addSublayer(previewLayer!)
        
        DispatchQueue.main.async { [weak self] in
            self?.captureSession?.startRunning()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = self.bounds
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let scannedString = metadataObject.stringValue else { return }
        
        onQRCodeScanned?(scannedString)
        captureSession?.stopRunning()
    }
    
    func startScanning() {
        if !(captureSession?.isRunning ?? false) {
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession?.startRunning()
            }
        }
    }
    
    func stopScanning() {
        if captureSession?.isRunning ?? false {
            captureSession?.stopRunning()
        }
    }
    
    // MARK: - 🔴 Fully turn off & release camera
    func turnOffCamera() {
        if captureSession?.isRunning ?? false {
            captureSession?.stopRunning()
        }
        
        captureSession?.inputs.forEach { captureSession?.removeInput($0) }
        captureSession?.outputs.forEach { captureSession?.removeOutput($0) }
        
        previewLayer?.removeFromSuperlayer()
        previewLayer = nil
        captureSession = nil
    }
}
