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
import Photos

final class AnalysisHelper {
    static let shared = AnalysisHelper()
    var treeModel = TreeModel()
    
    init(treeModel: TreeModel = TreeModel()) {
        self.treeModel = treeModel
    }
    
    func startAnalysis(canvasView: PKCanvasView) async -> TreeModel {
        saveDrawing(canvasView: canvasView)
        checkDrawingContainment(canvasView: canvasView)
        await analyzeTreeShadowPercentage(canvasView: canvasView)
        return treeModel
    }
    
    // 描画をUIImageとして保存
    func saveDrawing(canvasView: PKCanvasView) {
        
        Task { @MainActor in
            let image = canvasView.drawing.image(from: canvasView.bounds, scale: 1.0)
            treeModel.savedImage = image
            saveAlbum()
        }
    }
    
    func saveAlbum() {
        
        PHPhotoLibrary.requestAuthorization { [self] status in
            switch status {
            case .authorized:
                UIImageWriteToSavedPhotosAlbum(treeModel.savedImage, nil, #selector(imageDidFinishSaving), nil)
            case .denied, .restricted:
                print("Photo library access denied")
            case .notDetermined:
                print("Photo library access not determined")
            case .limited:
                UIImageWriteToSavedPhotosAlbum(treeModel.savedImage, nil, #selector(imageDidFinishSaving), nil)
            @unknown default:
                break
            }
        }
    }
    
    @objc func imageDidFinishSaving(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Error saving image: \(error.localizedDescription)")
        } else {
            print("Image saved successfully")
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
    
    func analyzeTreeShadowPercentage(canvasView: PKCanvasView) async {
        do {
            let image = await canvasView.drawing.image(from: canvasView.bounds, scale: 1.0)
            let targetSize = CGSize(width: 299, height: 299)
            UIGraphicsBeginImageContextWithOptions(targetSize, true, 1.0)
            UIColor.white.setFill()
            UIRectFill(CGRect(origin: .zero, size: targetSize))
            image.draw(in: CGRect(origin: .zero, size: targetSize))
            
            guard let resizedImage = UIGraphicsGetImageFromCurrentImageContext() else {
                UIGraphicsEndImageContext()
                return
            }
            
            UIGraphicsEndImageContext()
            
            guard let cgImage = resizedImage.cgImage else {
                return
            }
            
            // モデルの読み込みを安全に行う
            guard let modelURL = Bundle.main.url(forResource: "TreeImageClassifierTreeShadow", withExtension: "mlmodelc") else {
                return
            }
            
            // 複雑なネストを避け、段階的に初期化
            let mlModel: MLModel
            do {
                mlModel = try MLModel(contentsOf: modelURL)
            } catch {
                print("MLModelの読み込みに失敗しました: \(error)")
                return
            }
            
            let vnModel: VNCoreMLModel
            do {
                vnModel = try VNCoreMLModel(for: mlModel)
            } catch {
                print("VNCoreMLModelの作成に失敗しました: \(error)")
                return
            }
            
            // 画像分類リクエスト
            let request = VNCoreMLRequest(model: vnModel)
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            
            try handler.perform([request])
            
            // 結果の処理
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else {
                print("分類結果が取得できませんでした")
                return
            }
            
            let confidencePercentage = Int(topResult.confidence * 100)
            print("分類結果: \(topResult.identifier) (\(confidencePercentage)%)")
            
            let hasShading = topResult.identifier == "tree_on_shadow"
            
            await MainActor.run {
                self.treeModel.hasShading = hasShading
            }
            
        } catch {
            print("エラー発生: \(error.localizedDescription)")
        }
    }
}
