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
    @State private var savedImage: UIImage? = nil
    @State private var isPresented = false
    
    enum ToolType {
        case pencil, eraser
    }
    
    var body: some View {
        ZStack {
            VStack {
                
                CanvasView(canvasView: $canvasView)
                    .border(Color.black, width: 1)
                
                ToolPalette(selectedToolType: $selectedToolType, selectedColor: $selectedColor, canvasView: $canvasView)
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    .shadow(radius: 5)
                    
                
                HStack {
                    Button(action: {
                        saveDrawing()
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
                    
                    Button(action: {
                        saveDrawing()
                    }) {
                        
                        ZStack {
                            Text("Diagnosis 50% up")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                            Image(systemName: "lock.fill")
                                .foregroundColor(.black)
                                .offset(x: 45, y: 20)
                        }
                    }
                    .padding()
                    .shadow(radius: 4)
                    .foregroundColor(.black)
                    .background(LinearGradient(colors: [.yellow, .pink], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .cornerRadius(8)
                    
                    Button(action: {
                        saveDrawing()
                    }) {
                        ZStack {
                            Text("Diagnosis 100% up")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                            Image(systemName: "lock.fill")
                                .foregroundColor(.black)
                                .offset(x: 45, y: 20)
                        }
                    }
                    .padding()
                    .shadow(radius: 4)
                    .foregroundColor(.black)
                    .background(LinearGradient(colors: [.blue, .pink], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .cornerRadius(8)
                    
                }

            }
            .padding()
            .onAppear {
                setupCanvas()
            }
        }
        .background(.black)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .fullScreenCover(isPresented: $isPresented) {
            DiagnosisView(savedImage: $savedImage, isPresented: $isPresented)
        }
    }
    
    // PKCanvasViewの設定
    func setupCanvas() {
        canvasView.drawingPolicy = .anyInput // 指でもApple Pencilでも描画可能に
    }
    
    // 描画をUIImageとして保存
    func saveDrawing() {
        let image = canvasView.drawing.image(from: canvasView.bounds, scale: 1.0)
        savedImage = image
        isPresented = true
    }
    
    
}

// ツールパレットのビュー
struct ToolPalette: View {
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
        }
        print("a")
    }
    
    
    
}


struct DiagnosisView: View {
    @Binding var savedImage: UIImage?
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.black)
                            
                    }
                }
                
                
                if let image = savedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .border(Color.black, width: 1)
                }
                

                Text("用紙の大きさの 倍")
                    .font(.headline)
                    .padding()
            }
            .padding()
            .background(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
    }
}


#Preview {
    PencilView()
}
