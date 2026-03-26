//
//  ColoredSegment.swift
//  write
//
//  Created by 李天 on 2026/3/10.
//

import Foundation
import CoreGraphics

// 將每一段筆跡拆解成帶有起點、終點與壓力值的微小線段
struct ColoredSegment: Identifiable {
    let id = UUID()
    let startPoint: CGPoint
    let endPoint: CGPoint
    let force: CGFloat
}
