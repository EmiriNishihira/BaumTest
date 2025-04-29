//
//  ContentView.swift
//  BaumTest
//
//  Created by 中森えみり on 2024/10/01.
//

import SwiftUI

struct StartView: View {
    @State private var isPresented = false
    @AppStorage("isExisting") private var isExisting: Bool = false
    
    var body: some View {
        ZStack {
            Color.black
            VStack {
                Text("Baum Test")
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Button {
                    isPresented = true
                    isExisting = true
                } label: {
                    Text("Start")
                        .foregroundStyle(.black)
                        .frame(width: 200, height: 50)
                        .background {
                            Color.white
                        }
                        .cornerRadius(30)
                }
                .fullScreenCover(isPresented: $isPresented) {
                    PencilView()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        
    }
}

#Preview {
    StartView()
}
