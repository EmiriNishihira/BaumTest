//
//  BaumTestApp.swift
//  BaumTest
//
//  Created by 中森えみり on 2024/10/01.
//

import SwiftUI

@main
struct BaumTestApp: App {
    @AppStorage("isExisting") private var isExisting: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if isExisting {
                PencilView()
            } else {
                StartView()
            }
        }
    }
}
