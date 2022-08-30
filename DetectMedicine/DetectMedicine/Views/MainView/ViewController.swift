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
    
    //MARK: - components
    
    // capture
    var session: AVCaptureSession?
    let output = AVCapturePhotoOutput()
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    // shutter button
    private let shutterButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        button.layer.cornerRadius = 50
        button.layer.borderWidth = 10
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()

    // result view
    private let resultView: UITextView = {
       let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerRadius = 10
        textView.backgroundColor = .white
        textView.text = "description\ndescription\ndescription\ndescription\ndescription\ndescription\ndescription\ndescription\ndescription\ndescription\ndescription\ndescription\ndescription\ndescription\ndescription\ndescription\ndescription\ndescription\ndescription\ndescription\ndescription\ndescription\ndescription\n"
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.isHidden = true
        return textView
    }()
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.layer.addSublayer(previewLayer)
        view.addSubview(shutterButton)
        checkCameraPermissions()
        setupView()
        setVoiceOver()
        shutterButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
        shutterButton.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height - 100)
    }
    
    // MARK: - Custom functions
    // check permission
    private func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else {
                    return
                }
                
                DispatchQueue.main.async {
                    self?.setUpCamera()
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setUpCamera()
        @unknown default:
            break
     
        }
    }
    
    private func setUpCamera() {
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                
                if session.canAddOutput(output) {
                    session.addOutput(output)
                }
                
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                
                session.startRunning()
                self.session = session
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
     private func recognizeText(_ image: UIImage) {
        let options = KoreanTextRecognizerOptions()
        let koreanTextRecognizer = TextRecognizer.textRecognizer(options: options)
        let visionImage = VisionImage(image: image)
        visionImage.orientation = image.imageOrientation
        
        koreanTextRecognizer.process(visionImage) { result, error in
            guard error == nil, let result = result else {
                print(error?.localizedDescription as Any)
                return
            }
            UIAccessibility.post(notification: .announcement, argument: result.text)
            self.resultView.text = result.text
            self.resultView.isHidden = false
        }
         
    }
    
    private func setupView() {
        view.addSubview(resultView)
        NSLayoutConstraint.activate([
            resultView.heightAnchor.constraint(equalToConstant: 300),
            resultView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            resultView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            resultView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30)
        ])
    }
    
    private func setVoiceOver() {
        shutterButton.accessibilityLabel = "사진찍기"
        shutterButton.accessibilityHint = "이중탭하면 약의 사진을 촬영합니다."
        resultView.accessibilityLabel = "인식 결과"
        resultView.isAccessibilityElement = true
        resultView.accessibilityTraits = .staticText
    }
    
    @objc private func didTapTakePhoto() {
        output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
    
}

extension ViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation() else {
            return
        }
        
        session?.stopRunning()
        
        let image = UIImage(data: data)
        recognizeText(image!)
        session?.startRunning()
    }
}
