//
//  DetectMedicine.swift
//  DetectMedicine
//
//  Created by 이지원 on 2022/08/31.
//

import UIKit
import Vision

class DetectMedicineModel {
    
    static func createImageClassifier() -> VNCoreMLModel {
        
        let defaultConfig = MLModelConfiguration()
        let imageClassifierWrapper = try? DetectMedicine(configuration: defaultConfig)
        
        guard let imageClassifier = imageClassifierWrapper else {
            fatalError("App failed to create an image classifier model instance")
        }
        
        let imageClassifierModel = imageClassifier.model
        
        guard let imageClassifierVisionModel = try? VNCoreMLModel(for: imageClassifierModel) else {
            fatalError("App failed to create a VNCoreModel instance")
        }
        
        return imageClassifierVisionModel
    }
    
    private static let imageClassifier = createImageClassifier()
    
    struct Prediction {
        let classification: String
        let confidencePercentage: String
    }
    
    typealias ImagePredictionHandler = (_ predictions: [Prediction]?) -> Void
    
    private var predictionHandlers = [VNRequest: ImagePredictionHandler]()
    
    private func createImageClassificationRequest() -> VNImageBasedRequest {
        let imageClassificationRequest = VNCoreMLRequest(model: DetectMedicineModel.imageClassifier, completionHandler: visionRequestHandler)
        imageClassificationRequest.imageCropAndScaleOption = .centerCrop
        return imageClassificationRequest
    }
    
    func makePredictions(for photo: UIImage, completionHandler: @escaping ImagePredictionHandler) throws {
        let orientation = CGImagePropertyOrientation(photo.imageOrientation)

        guard let photoImage = photo.cgImage else {
            fatalError("Photo doesn't have underlying CGImage.")
        }

        let imageClassificationRequest = createImageClassificationRequest()
        predictionHandlers[imageClassificationRequest] = completionHandler

        let handler = VNImageRequestHandler(cgImage: photoImage, orientation: orientation)
        let requests: [VNRequest] = [imageClassificationRequest]

        // Start the image classification request.
        try handler.perform(requests)
    }
    
    private func visionRequestHandler(_ request: VNRequest, error: Error?) {
        guard let predictionHandler = predictionHandlers.removeValue(forKey: request) else {
            fatalError("Every request must have a prediction handler.")
        }
        
        var predictions: [Prediction]? = nil
        defer {
            predictionHandler(predictions)
        }
        
        if let error = error {
            print("Vision image classification error \(error.localizedDescription)")
            return
        }
        
        if request.results == nil {
            print("Vision request had no results")
            return
        }
        
        guard let observations = request.results as?
                [VNClassificationObservation] else {
            print("VNRequest produced the wrong result type: \(type(of: request.results))")
            return
        }
        
        predictions = observations.map { observation in
            Prediction(classification: observation.identifier,
                       confidencePercentage: observation.confidencePercentageString)
        }
    }
}
