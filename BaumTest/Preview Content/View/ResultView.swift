//
//  ResultView.swift
//  BaumTest
//
//  Created by えみり on 2024/12/06.
//

import SwiftUI

struct ResultView: View {
    @Bindable var treeModel: TreeModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.black)
                            
                    }
                }
                
                Image(uiImage: treeModel.savedImage)
                    .resizable()
                    .scaledToFit()
                    .border(Color.black, width: 1)
                
                Text("用紙のサイズ\(treeModel.sizeType)")
                Text("用紙の位置\(treeModel.positionType)")
                Text("陰影の有無: \(treeModel.hasShading ? "あり" : "なし")")

            }
            .padding()
            .background(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
    }
}
