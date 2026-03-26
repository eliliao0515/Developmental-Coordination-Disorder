//
//  shapeManeger.swift
//  write
//
//  Created by 李天 on 2026/3/17.
//

import Foundation
import SwiftUI
import Combine

struct shapeModel: Identifiable{
    let id = UUID()
    let levelNumber: Int
    let shape: String
}

class shapeViewModel: ObservableObject {
    @Published var levels: [shapeModel] = [
        shapeModel(levelNumber: 1, shape: "Circle"),
        shapeModel(levelNumber: 2, shape: "Cross"),
        shapeModel(levelNumber: 3, shape: "Square"),
        shapeModel(levelNumber: 4, shape: "Composite"),
        shapeModel(levelNumber: 5, shape: "Bu"),
        shapeModel(levelNumber: 6, shape: "Bu"),
        shapeModel(levelNumber: 7, shape: "Bu"),
        shapeModel(levelNumber: 8, shape: "Bu")
    ]
}
