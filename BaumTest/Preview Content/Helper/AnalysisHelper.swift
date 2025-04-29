//
//  AnalysisHelper.swift
//  BaumTest
//
//  Created by えみり on 2025/04/29.
//

import Foundation
import SwiftUI
import PencilKit
import Vision

final class AnalysisHelper {
    static let shared = AnalysisHelper()
    var treeModel = TreeModel()
    
    init(treeModel: TreeModel = TreeModel()) {
        self.treeModel = treeModel
    }
    
    func startAnalysis(canvasView: PKCanvasView) async -> TreeModel {
        saveDrawing(canvasView: canvasView)
        checkDrawingContainment(canvasView: canvasView)
//        await detectShading(canvasView: canvasView)
        return treeModel
    }
    
    // 描画をUIImageとして保存
    func saveDrawing(canvasView: PKCanvasView) {
        
        Task { @MainActor in
            let image = canvasView.drawing.image(from: canvasView.bounds, scale: 1.0)
            treeModel.savedImage = image
        }
    }
    
    func checkDrawingContainment(canvasView: PKCanvasView) {
        let drawingBounds = canvasView.drawing.bounds
        print("描いた\(drawingBounds)")
        
        Task { @MainActor in
            let canvasWidth = canvasView.frame.width
            let canvasHeight = canvasView.frame.height
            
            
            // 描画がビューにどのくらい収まっているかの割合を計算
            let ratio = (drawingBounds.width * drawingBounds.height) / (canvasWidth * canvasHeight)
            // 横幅と高さの最小値を取って、収まっている割合を計算
            setUpSizeType(ratio: ratio)
            
            let drawX = drawingBounds.origin.x
            let drawY = drawingBounds.origin.y
            setUpPosition(x: drawX, y: drawY, canvasView: canvasView)
        }
    }
    
    func setUpSizeType(ratio: CGFloat) {
        if ratio < 0.2 {
            treeModel.sizeType = .small
        } else {
            if ratio >= 0.8 {
                treeModel.sizeType = .large
            } else if ratio <= 0.6 {
                treeModel.sizeType = .medium
            }
        }
        print("収まり具合\(ratio)")
    }
    
    func setUpPosition(x: CGFloat, y: CGFloat, canvasView: PKCanvasView) {
        
        if treeModel.sizeType == .small {
            let margins = calculateMargins(canvasView: canvasView)
            
            if margins.left < 70 && margins.top < 70 {
                treeModel.positionType = .topLeading
            } else if margins.left < 70 && margins.bottom < 70 {
                treeModel.positionType = .bottomLeading
            } else if margins.top < 70 && margins.right < 70 {
                treeModel.positionType = .topTrailing
            } else if margins.right < 70 && margins.bottom < 70 {
                treeModel.positionType = .bottomTrailing
            } else {
                treeModel.positionType = .center
            }
            print("small版, top:\(margins.top), bottom:\(margins.bottom), left:\(margins.left), right:\(margins.right)")
        } else if treeModel.sizeType == .medium {
            let margins = calculateMargins(canvasView: canvasView)
            if margins.right <  10 {
                treeModel.positionType = .trailing
            } else if margins.left < 10 {
                treeModel.positionType = .leading
            } else {
                treeModel.positionType = .center
            }
            print("medium版, top:\(margins.top), bottom:\(margins.bottom), left:\(margins.left), right:\(margins.right)")
        } else if treeModel.sizeType == .large {
            treeModel.positionType = .center
        }
    }
    
    func calculateMargins(canvasView: PKCanvasView) -> UIEdgeInsets {
        let drawingBounds = canvasView.drawing.bounds
        let canvasSize = canvasView.bounds.size
        
        let topMargin = drawingBounds.minY
        let bottomMargin = canvasSize.height - drawingBounds.maxY
        let leftMargin = drawingBounds.minX
        let rightMargin = canvasSize.width - drawingBounds.maxX
        
        return UIEdgeInsets(top: topMargin, left: leftMargin, bottom: bottomMargin, right: rightMargin)
    }
//
//    func detectShading(canvasView: PKCanvasView) async {
//        guard let model = try? VNCoreMLModel(for: ShadingClassifier(configuration: MLModelConfiguration()).model) else {
//            print("Could not load Core ML model")
//            return
//        }
//        
//        await MainActor.run {
//            let image = canvasView.drawing.image(from: canvasView.bounds, scale: 1.0)
//            
//            guard let ciImage = CIImage(image: image) else {
//                print("Could not convert to CIImage")
//                return
//            }
//            
//            let request = VNCoreMLRequest(model: model) { [weak self] request, error in
//                guard let results = request.results as? [VNClassificationObservation] else {
//                    print("Could not get classification results")
//                    return
//                }
//                
//                // 最初の結果を使用（陰影があるクラス）
//                let hasShading = results.first?.identifier == "hasShading" &&
//                                 (results.first?.confidence ?? 0) > 0.5
//                
//                Task { @MainActor in
//                    self?.treeModel.hasShading = hasShading
//                    print("Shading Detection Result: \(hasShading)")
//                }
//            }
//            
//            let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
//            
//            do {
//                try handler.perform([request])
//            } catch {
//                print("Failed to perform classification: \(error)")
//            }
//        }
//    }
}
