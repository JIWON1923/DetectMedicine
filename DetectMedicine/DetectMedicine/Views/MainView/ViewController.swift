//
//  ViewController.swift
//  DetectMedicine
//
//  Created by 이지원 on 2022/08/27.
//

import UIKit
import AVFoundation
import MLKitTextRecognitionKorean
import MLKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cameraView: UIView!
    // snapshot
    var videoDataOutput: AVCaptureVideoDataOutput!
    var videoDataOutputQueue: DispatchQueue!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var captureDevice: AVCaptureDevice!
    let session = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAVCapture()
    }
    
    override var shouldAutorotate: Bool {
        let orientation = UIDevice.current.orientation
        let UIOrientation = UIDeviceOrientation.self
        
        if orientation == UIOrientation.landscapeLeft ||
            orientation == UIOrientation.landscapeRight ||
            orientation == UIOrientation.unknown {
            return false
        }
        return true
    }
    
    // func recognizeText(_ image: UIImage) {
    func recognizeText() {
        let image = UIImage(named: "tyrenol.jpeg")!
        let options = KoreanTextRecognizerOptions()
        let koreanTextRecognizer = TextRecognizer.textRecognizer(options: options)
        let visionImage = VisionImage(image: image)
        visionImage.orientation = image.imageOrientation
        
        koreanTextRecognizer.process(visionImage) { result, error in
            guard error == nil, let result = result else {
                print(error?.localizedDescription)
                return
            }
            print(result.text)
        }
    }
    
    @IBAction func didTapSnapButton(_ sender: Any) {
        print("tapped!")
        if session.isRunning {
            DispatchQueue.main.async {
                self.session.stopRunning()
                sleep(3)
                self.session.startRunning()
            }
            
        }
//        recognizeText(cameraView.takeSnapshot())
        recognizeText()
    }
    
}

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func setAVCapture() {
        session.sessionPreset = AVCaptureSession.Preset.vga640x480
        guard let device = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera,
                                                   for: .video,
                                                   position: AVCaptureDevice.Position.back) else {
            return
        }
        captureDevice = device
        beginSession()
    }
    
    func beginSession() {
        var deviceInput: AVCaptureDeviceInput!
        
        do {
            deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            guard deviceInput != nil else {
                print("device Input Error")
                return
            }
            
            if self.session.canAddInput(deviceInput) {
                self.session.addInput(deviceInput)
            }
            
            videoDataOutput = AVCaptureVideoDataOutput()
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            videoDataOutputQueue = DispatchQueue(label: "VideoDataOutputQueue")
            videoDataOutput.setSampleBufferDelegate(self, queue: self.videoDataOutputQueue)
            
            if session.canAddOutput(self.videoDataOutput) {
                session.addOutput(self.videoDataOutput)
            }
            
            videoDataOutput.connection(with: .video)?.isEnabled = true
            
            previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspect
            
            let rootLayer: CALayer = cameraView.layer
            rootLayer.masksToBounds = true
            previewLayer.frame = rootLayer.bounds
            rootLayer.addSublayer(self.previewLayer)
            session.startRunning()
        } catch let error as NSError {
            deviceInput = nil
            print(error.localizedDescription)
        }
    }
    
}
