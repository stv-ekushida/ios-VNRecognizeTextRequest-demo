//
//  ViewController.swift
//  ios-VNRecognizeTextRequest-demo
//
//  Created by eiji kushida on 2020/03/03.
//  Copyright © 2020 eiji kushida. All rights reserved.
//

import UIKit
import Vision

final class ViewController: UIViewController {
    
    @IBOutlet private weak var ocrTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = #imageLiteral(resourceName: "word")
        guard let cgImage = image.cgImage else {
            return
        }
        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)

        // accurate or fast
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["en_US"] // ja_JPは、認識せず
        request.usesLanguageCorrection = true
        let requests = [request]
        let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage,  options: [:])
        
        do {
            try imageRequestHandler.perform(requests)
        } catch {
            print("error")
        }
    }
    
    func recognizeTextHandler(request: VNRequest?, error: Error?) {
        guard let observations = request?.results as? [VNRecognizedTextObservation] else {
            return
        }

        var detectedText = ""
        
        for observation in observations {
            let candidates = 1
            guard let bestCandidate = observation.topCandidates(candidates).first else {
                continue
            }
            
            //文字認識結果
            detectedText += bestCandidate.string
            detectedText += "\n"
        }
        
        print("検出文字列 : ", detectedText)
        
        DispatchQueue.main.async {
            self.ocrTextLabel.text = detectedText
        }
    }
}

