//
//  DrawingManager.swift
//  write
//
//  Created by 李天 on 2026/3/10.
//

import Foundation
import Combine
// 狀態管理員，負責儲存畫布上的所有線段
class DrawingManager: ObservableObject {
    @Published var segments: [ColoredSegment] = []
    
    @Published var allStrokes: [Stroke] = []
}
