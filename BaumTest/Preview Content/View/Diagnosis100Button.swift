//
//  Diagnosis100Button.swift
//  BaumTest
//
//  Created by えみり on 2024/12/06.
//

import SwiftUI

struct Diagnosis100Button: View {
    var body: some View {
        Button(action: {
            //            saveDrawing()
        }) {
            ZStack {
                Text("Diagnosis 100% up")
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
        .background(LinearGradient(colors: [.blue, .pink], startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(8)
    }
}

#Preview {
    Diagnosis100Button()
}
