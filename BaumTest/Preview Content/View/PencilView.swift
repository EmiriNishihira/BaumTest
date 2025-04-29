//
//  PencilView.swift
//  BaumTest
//
//  Created by 中森えみり on 2024/10/05.
//

import SwiftUI
import PencilKit

struct PencilView: View {
    @State private var canvasView = PKCanvasView()
    @State private var selectedColor: UIColor = .black
    @State private var selectedToolType: ToolType = .pencil
    @State private var isFullyContained: Bool = false
    
    enum ToolType {
        case pencil, eraser, paper
    }
    
    var body: some View {
        ZStack {
            VStack {
                GeometryReader { geometry in
                    CanvasView(canvasView: $canvasView)
                        .border(Color.black, width: 1)
                }
                ToolPaletteView(selectedToolType: $selectedToolType, selectedColor: $selectedColor, canvasView: $canvasView)
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    .shadow(radius: 5)
                    
                
                HStack {
                    DiagnosisButton(canvasView: $canvasView, status: .loding)
                    
                    Diagnosis50Button()
                    
                    Diagnosis100Button()
                }

            }
            .padding()
            .onAppear {
                setupCanvas()
            }
        }
        .background(.black)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // PKCanvasViewの設定
    func setupCanvas() {
        canvasView.drawingPolicy = .anyInput // 指でもApple Pencilでも描画可能に
    }
    

}


#Preview {
    PencilView()
}
