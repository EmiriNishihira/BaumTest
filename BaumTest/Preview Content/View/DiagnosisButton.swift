//
//  DiagnosisButton.swift
//  BaumTest
//
//  Created by えみり on 2024/12/06.
//

import SwiftUI
import PencilKit

struct DiagnosisButton: View {
    @State private var savedImage = UIImage()
    @State private var isPresented = false
    @Binding var canvasView: PKCanvasView
    @State private var treeModel = TreeModel()
    @State var status: AnalyticsStatus {
        didSet {
            switch status {
            case .loding:
                print("解析中です😎")
            case .completed:
                print("解析終わりました🥰")
                isPresented = true
            }
        }
    }
    
    var body: some View {
        Button(action: {
            status = .loding
            saveDrawing()
            status = .completed
        }) {
            Text("Diagnosis Standard")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(LinearGradient(colors: [.cyan, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
                .foregroundColor(.black)
                .cornerRadius(8)
                .shadow(radius: 4)
        }
        .fullScreenCover(isPresented: $isPresented) {
            ResultView(savedImage: $savedImage, treeModel: $treeModel)
        }
    }
    
    // 描画をUIImageとして保存
    func saveDrawing() {
        let image = canvasView.drawing.image(from: canvasView.bounds, scale: 1.0)
        savedImage = image
        isPresented = true
        
        checkDrawingContainment()
    }
    
    func checkDrawingContainment() {
        let drawingBounds = canvasView.drawing.bounds
        print("描いた\(drawingBounds)")
        // CanvasViewのサイズをパディングを考慮して取得
        let canvasWidth = canvasView.frame.width
        let canvasHeight = canvasView.frame.height
        
        
        // 描画がビューにどのくらい収まっているかの割合を計算
        let ratio = (drawingBounds.width * drawingBounds.height) / (canvasWidth * canvasHeight)
        // 横幅と高さの最小値を取って、収まっている割合を計算
        setUpSizeType(ratio: ratio)
        
        let drawX = drawingBounds.origin.x
        let drawY = drawingBounds.origin.y
        setUpPosition(x: drawX, y: drawY)
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
    
    func setUpPosition(x: CGFloat, y: CGFloat) {
        
        if treeModel.sizeType == .small {
            let margins = calculateMargins()
            
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
            let margins = calculateMargins()
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
    
    func calculateMargins() -> UIEdgeInsets {
        let drawingBounds = canvasView.drawing.bounds
        let canvasSize = canvasView.bounds.size
        
        let topMargin = drawingBounds.minY
        let bottomMargin = canvasSize.height - drawingBounds.maxY
        let leftMargin = drawingBounds.minX
        let rightMargin = canvasSize.width - drawingBounds.maxX
        
        return UIEdgeInsets(top: topMargin, left: leftMargin, bottom: bottomMargin, right: rightMargin)
    }
}
