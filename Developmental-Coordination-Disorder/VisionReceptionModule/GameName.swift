//
//  GameName.swift
//  DCDApp
//
//  Created by 訪客使用者 on 2026/3/20.
//

import Foundation
import SwiftUI

enum GameName: String, CaseIterable {
    case memory = "MemoryView"
    case recognition = "RecognitionView"
    case space = "SpaceView"
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .memory: MemoryView()
        case .recognition: RecognitionView()
        case .space: SpaceView()
        }
    }
}
