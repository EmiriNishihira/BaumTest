//
//  ToolPaletteView.swift
//  BaumTest
//
//  Created by えみり on 2024/12/06.
//

import SwiftUI
import PencilKit

struct ToolPaletteView: View {
    @Binding var selectedToolType: PencilView.ToolType
    @Binding var selectedColor: UIColor
    @Binding var canvasView: PKCanvasView
    
    var body: some View {
        VStack {
            HStack {
                // 鉛筆
                Button(action: {
                    selectedToolType = .pencil
                    setTool()
                }) {
                    VStack {
                        Image(systemName: "pencil.and.outline")
                        Text("Pencil")
                    }
                    .padding()
                    .background(selectedToolType == .pencil ? Color.black : Color.clear)
                    .cornerRadius(8)
                    .foregroundColor(.white)
                }
                
                // 消しゴム
                Button(action: {
                    selectedToolType = .eraser
                    setTool()
                }) {
                    VStack {
                        Image(systemName: "eraser")
                        Text("Eraser")
                    }
                    .padding()
                    .background(selectedToolType == .eraser ? Color.black : Color.clear)
                    .cornerRadius(8)
                    .foregroundColor(.white)
                }
                
                Button(action: {
                    selectedToolType = .paper
                    setTool()
                }) {
                    VStack {
                        Image(systemName: "document")
                        Text("Clear")
                    }
                    .padding()
                    .background(selectedToolType == .paper ? Color.black : Color.clear)
                    .cornerRadius(8)
                    .foregroundColor(.white)
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            setTool()
        }
    }
    
    // ツールを設定する関数
    func setTool() {
        switch selectedToolType {
        case .pencil:
            let pencil = PKInkingTool(.pencil, color: selectedColor, width: 3)
            canvasView.tool = pencil
        case .eraser:
            canvasView.tool = PKEraserTool(.bitmap, width: 5)
        case .paper:
            canvasView.drawing = PKDrawing()
        }

    }
}
