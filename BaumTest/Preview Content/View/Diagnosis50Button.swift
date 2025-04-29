//
//  Diagnosis50Button.swift
//  BaumTest
//
//  Created by えみり on 2024/12/06.
//

import SwiftUI

struct Diagnosis50Button: View {
    var body: some View {
        Button(action: {
//            saveDrawing()
        }) {
            
            ZStack {
                Text("Diagnosis 50% up")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                Image(systemName: "star.fill")
                    .foregroundColor(.black)
                    .offset(x: 45, y: 20)
            }
        }
        .padding()
        .shadow(radius: 4)
        .foregroundColor(.black)
        .background(LinearGradient(colors: [.yellow, .pink], startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(8)
    }
}

#Preview {
    Diagnosis50Button()
}
