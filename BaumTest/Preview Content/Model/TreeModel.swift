//
//  TreeModel.swift
//  BaumTest
//
//  Created by 中森えみり on 2024/10/06.
//

import SwiftUI

@Observable
class TreeModel {
    var sizeType: SizeType = .small
    var positionType: PositionType = .top
    var hasShading: Bool = false
    var savedImage: UIImage = UIImage()
}
