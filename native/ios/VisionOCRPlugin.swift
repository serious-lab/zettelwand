//
//  VisionOCRPlugin.swift
//  Zettelwand
//
//  Texterkennung (auch Handschrift) direkt auf dem Gerät mit Apple Vision.
//  JavaScript-Seite: Capacitor.registerPlugin('VisionOCR').recognize({ image: <Base64>, languages: ['de-DE','en-US'] })
//  Antwort: { text: String, lines: [String] }
//

import Foundation
import UIKit
import Vision
import Capacitor

@objc(VisionOCRPlugin)
public class VisionOCRPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "VisionOCRPlugin"
    public let jsName = "VisionOCR"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "recognize", returnType: CAPPluginReturnPromise)
    ]

    @objc func recognize(_ call: CAPPluginCall) {
        guard let base64 = call.getString("image"),
              let data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters),
              let image = UIImage(data: data),
              let cgImage = image.cgImage else {
            call.reject("Das Bild konnte nicht gelesen werden.")
            return
        }
        let languages = call.getArray("languages", String.self) ?? ["de-DE", "en-US"]

        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                call.reject(error.localizedDescription)
                return
            }
            let observations = (request.results as? [VNRecognizedTextObservation]) ?? []
            // Vision-Koordinaten beginnen unten links: höhere minY = weiter oben im Bild
            let lines = observations
                .sorted { $0.boundingBox.minY > $1.boundingBox.minY }
                .compactMap { $0.topCandidates(1).first?.string }
            call.resolve([
                "text": lines.joined(separator: "\n"),
                "lines": lines
            ])
        }
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        let supported = (try? request.supportedRecognitionLanguages()) ?? []
        let usable = languages.filter { supported.contains($0) }
        if !usable.isEmpty { request.recognitionLanguages = usable }

        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(cgImage: cgImage, orientation: orientation, options: [:])
            do {
                try handler.perform([request])
            } catch {
                call.reject(error.localizedDescription)
            }
        }
    }
}

extension CGImagePropertyOrientation {
    init(_ o: UIImage.Orientation) {
        switch o {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        @unknown default: self = .up
        }
    }
}
