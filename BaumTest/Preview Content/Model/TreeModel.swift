//
//  TreeModel.swift
//  BaumTest
//
//  Created by 中森えみり on 2024/10/06.
//

import SwiftUI

class TreeModel: ObservableObject {
    @Published var sizeType: SizeType = .small
    @Published var positionType: PositionType = .top
}
