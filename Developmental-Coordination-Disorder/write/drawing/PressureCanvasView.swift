//
//  PressureCanvasView.swift
//  write
//
//  Created by 李天 on 2026/3/10.
//

import SwiftUI

struct PressureCanvasView: View {
    @ObservedObject var drawingManager = DrawingManager()
    
    // 固定的引導線與筆跡粗細
    let guideLineWidth: CGFloat = 45.0
    let pencilLineWidth: CGFloat = 30.0
    
    let shape: String
    var body: some View {
        VStack(spacing: 20) {
            // 畫布區塊
            ZStack {
                // 第 1 層 (底層)：引導線
                // 底層的粗灰引導線
                switch shape {
                case "Cross":
                    CrossShape(currentLineWidth: guideLineWidth)
                        .stroke(
                            Color.gray.opacity(0.3),
                            style: StrokeStyle(lineWidth: guideLineWidth, lineCap: .round, lineJoin: .round)
                        )
                    // 疊加在上面的白色細箭頭
                    CrossArrowsShape(currentLineWidth: guideLineWidth)
                        .stroke(
                            Color.white,
                            style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round)
                        )
                case "Square":
                    SquareShape(currentLineWidth: guideLineWidth)
                        .stroke(
                            Color.gray.opacity(0.3),
                            style: StrokeStyle(lineWidth: guideLineWidth, lineCap: .round, lineJoin: .round)
                        )
                    // 疊加在上面的白色細箭頭
                    SquareArrowsShape(currentLineWidth: guideLineWidth)
                        .stroke(
                            Color.white,
                            style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round)
                        )
                case "Circle":
                    CircleShape(currentLineWidth: guideLineWidth)
                        .stroke(
                            Color.gray.opacity(0.3),
                            style: StrokeStyle(lineWidth: guideLineWidth, lineCap: .round, lineJoin: .round)
                        )
                    // 疊加在上面的白色細箭頭
                    CircleArrowsShape(currentLineWidth: guideLineWidth)
                        .stroke(
                            Color.white,
                            style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round)
                        )
                case "Composite":
                    CompositeShape(currentLineWidth: guideLineWidth)
                        .stroke(
                            Color.gray.opacity(0.3),
                            style: StrokeStyle(lineWidth: guideLineWidth, lineCap: .round, lineJoin: .round)
                        )
                    // 疊加在上面的白色細箭頭
                    CompositeArrowsShape(currentLineWidth: guideLineWidth)
                        .stroke(
                            Color.white,
                            style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round)
                        )
                case "Bu":
                    BuShape(currentLineWidth: guideLineWidth)
                        .stroke(
                            Color.gray.opacity(0.3),
                            style: StrokeStyle(lineWidth: guideLineWidth, lineCap: .round, lineJoin: .round)
                        )
                    // 疊加在上面的白色細箭頭
                    BuArrowsShape(currentLineWidth: guideLineWidth)
                        .stroke(
                            Color.white,
                            style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round)
                        )
                default:
                    EmptyView()
                }
                
                
                // 第 2 層 (渲染層)：讀取陣列，畫出帶有顏色的線段
                Canvas { context, size in
                    for segment in drawingManager.segments {
                        var path = Path()
                        path.move(to: segment.startPoint)
                        path.addLine(to: segment.endPoint)
                        
                        // 根據每段線的壓力值計算顏色
                        let segmentColor = ColorAlgorithm.color(for: segment.force)
                        
                        context.stroke(
                            path,
                            with: .color(segmentColor),
                            style: StrokeStyle(lineWidth: pencilLineWidth, lineCap: .round, lineJoin: .round)
                        )
                    }
                }
                
                // 第 3 層 (觸控攔截層)
                TouchCaptureRepresentable(manager: drawingManager)
            }
            .frame(width: 500, height: 500)
            .clipped() // 確保筆跡不會超出畫布邊界
        }
    }
}

#Preview {
    PressureCanvasView(shape: "Bu")
}
