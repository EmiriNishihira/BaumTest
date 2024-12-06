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
    @Binding var isPresented: Bool
    @ObservedObject var treeModel = TreeModel()
    
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
                    
//                    Button(action: {
//                        saveDrawing()
//                    }) {
//                        
//                        ZStack {
//                            Text("Diagnosis 50% up")
//                                .font(.headline)
//                                .frame(maxWidth: .infinity)
//                            Image(systemName: "lock.fill")
//                                .foregroundColor(.black)
//                                .offset(x: 45, y: 20)
//                        }
//                    }
//                    .padding()
//                    .shadow(radius: 4)
//                    .foregroundColor(.black)
//                    .background(LinearGradient(colors: [.yellow, .pink], startPoint: .topLeading, endPoint: .bottomTrailing))
//                    .cornerRadius(8)
//                    
//                    Button(action: {
//                        saveDrawing()
//                    }) {
//                        ZStack {
//                            Text("Diagnosis 100% up")
//                                .font(.headline)
//                                .frame(maxWidth: .infinity)
//                            Image(systemName: "lock.fill")
//                                .foregroundColor(.black)
//                                .offset(x: 45, y: 20)
//                        }
//                    }
//                    .padding()
//                    .shadow(radius: 4)
//                    .foregroundColor(.black)
//                    .background(LinearGradient(colors: [.blue, .pink], startPoint: .topLeading, endPoint: .bottomTrailing))
//                    .cornerRadius(8)
                    
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
    PencilView(isPresented: .constant(true))
}
