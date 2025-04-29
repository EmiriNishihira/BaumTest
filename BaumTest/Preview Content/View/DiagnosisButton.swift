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
            Task {
                await fetchData()
            }
            
            status = .completed
            isPresented = true
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
            ResultView(treeModel: treeModel)
        }
    }
    
    func fetchData() async {
        let resultModel = await AnalysisHelper.shared.startAnalysis(canvasView: canvasView)
        treeModel.sizeType = resultModel.sizeType
        treeModel.positionType = resultModel.positionType
        treeModel.hasShading = resultModel.hasShading
        treeModel.savedImage = resultModel.savedImage
    }
    
}
