//
//  ScannerViewController.swift
//  Elite
//
//  Created by Ibraheem rawlinson on 4/21/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//
import AVFoundation
import UIKit

class ScannerViewController: UIViewController {

    private let previewViewLayer = AVPreviewLayer()
    private let captureSession = CaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupViews()
        captureSession.configurePreview(view: previewViewLayer.previewLayer)
        configureMetadata()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let orientation = UIDevice.current.orientation
        let connection = previewViewLayer.previewLayer.avPreviewLayer.connection
        
        guard let videoOrientation = AVCaptureVideoOrientation(deviceOrientation: orientation)
            else { return }
        connection?.videoOrientation = videoOrientation
        captureSession.updateOrientation(orientation: videoOrientation)
    }
    private func setupViews(){
        setupImageView()
        setupQRFrame()
    }
    private func setupImageView(){
        view.addSubview(previewViewLayer)
        self.previewViewLayer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            previewViewLayer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            previewViewLayer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            previewViewLayer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            previewViewLayer.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ]) // active by defualt
        
    }
    private func setupQRFrame(){
        view.bringSubviewToFront(previewViewLayer.qrCodeFrameView)
    }
    
    private func configureMetadata() {
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.avSession.canAddOutput(metadataOutput)) {
            captureSession.avSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self , queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = captureSession.supportedCodeTypes
        }
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    
    func found(code: String) {
        let alertController = UIAlertController.init(title: "QR Code", message: "Here is what the qr code shows \(code)", preferredStyle: .alert)
        let okaction = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okaction)
        self.present(alertController, animated: true, completion: nil)
        print("The QR Code is",code)
    }
    
}

extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate{
    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is contains at least one object.
        if metadataObjects.count == 0 {
            previewViewLayer.qrCodeFrameView.frame = CGRect.zero
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if captureSession.supportedCodeTypes.contains(metadataObj.type){
            
            //            if metadataObj.type == AVMetadataObject.ObjectType.qr {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            guard let barCodeObject = previewViewLayer.previewLayer.avPreviewLayer.transformedMetadataObject(for: metadataObj) else { return }
            previewViewLayer.qrCodeFrameView.frame = barCodeObject.bounds
            if previewViewLayer.qrCodeFrameView.frame == barCodeObject.bounds {
                if metadataObj.stringValue != nil {
                    // handle what happens to the qr code string
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate)) // code snippet later
                    print("\(String(describing: metadataObj.stringValue))")
                    
                }
            }
            
            
            //            }
        }
    }
    
}
