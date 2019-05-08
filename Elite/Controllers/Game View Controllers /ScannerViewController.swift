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
    var user: String?
    weak var delegate: SearchForPlayerDelegate?
    weak var twoVsTwoSearchDelegate: twoVsTwoSearchDelegate?
    var scannedOtherGamer: GamerModel?
    var teamRole: TeamRoles!
    var gameType: GameType!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupViews()
        captureSession.configurePreview(view: previewViewLayer.previewLayer)
        configureMetadata()
        setupBttnView()
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
    private func setupBttnView(){
        
        let button = UIButton(frame: CGRect(x: 0, y: 20, width: 100, height: 25))
        button.backgroundColor = .clear
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.blue.cgColor
        button.setTitle("Cancel Scan", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        self.view.addSubview(button)
    }
    @objc private func buttonAction(){
        self.dismiss(animated: true, completion: nil)
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
                    guard let qrStr = metadataObj.stringValue else {
                        showAlert(title: "Error scanning QR code", message: "try again")
                        return
                    }
                    

                    DBService.fetchGamer(gamerID: qrStr) { (error, gamer) in
                        if let error = error {
                            self.showAlert(title: "Error fetching player", message: error.localizedDescription)
                        }
                        if let gamer = gamer {
                            var currentPlayer: CurrentPlayer!
                            if self.gameType == .oneVsOne {
                                self.delegate?.gamerSelected(gamer: gamer)

                            }
                            if self.gameType == .twoVsTwo{
                                if self.teamRole == .redTwo{
 
                                    self.twoVsTwoSearchDelegate?.redTwoPlayer(redTwoPlayer: gamer)
                                }
                                if self.teamRole == .blueOne{

                                    self.twoVsTwoSearchDelegate?.blueOnePlayer(blueOnePlayer: gamer)
                                }
                                if self.teamRole == .blueTwo{

                                    self.twoVsTwoSearchDelegate?.blueTwoPlayer(blueTwoPlayer: gamer)
                                }
                            }
                           
                            if let presentingViewController = self.presentingViewController.self?.presentingViewController{
                                presentingViewController.dismiss(animated: true)
                                
                            }
                            
                        }
                    }
                    
                   // dismiss(animated: true)
                }
            }
            
            
            //            }
        }
    }
    
}
extension ScannerViewController: SearchForPlayerDelegate{
    
    func gamerSelected(gamer: GamerModel) {
        self.scannedOtherGamer = gamer
    }
    
    
}
