//
//  SquareShape.swift
//  write
//
//  Created by 李天 on 2026/3/13.
//

import SwiftUI

// MARK: - 1. 底層基礎圖形 (粗灰線)

// 3. 方形
struct SquareShape: Shape {
    var currentLineWidth: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let dynamicPadding: CGFloat = (currentLineWidth / 2) + 10
        
        // 直接產生一個向內縮小 dynamicPadding 的安全矩形
        let safeRect = rect.insetBy(dx: dynamicPadding, dy: dynamicPadding)
        
        // 沿著安全矩形畫出方形路徑
        path.addRect(safeRect)
        
        return path
    }
}

// MARK: - 2. 上層箭頭圖形 (細白線)

// 方形專用的箭頭
struct SquareArrowsShape: Shape {
    var currentLineWidth: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let dynamicPadding: CGFloat = (currentLineWidth / 2) + 10
        let safeRect = rect.insetBy(dx: dynamicPadding, dy: dynamicPadding)
        let arrowSize: CGFloat = 16
        
        // 畫在上方邊緣的箭頭 (從左往右指)
        let topY = safeRect.minY
        let startX = safeRect.minX + safeRect.width * 0.15
        let endX = safeRect.minX + safeRect.width * 0.4
        
        // 畫箭頭身體
        path.move(to: CGPoint(x: startX, y: topY))
        path.addLine(to: CGPoint(x: endX, y: topY))
        
        // 畫箭頭兩翼
        path.move(to: CGPoint(x: endX - arrowSize, y: topY - arrowSize * 0.6))
        path.addLine(to: CGPoint(x: endX, y: topY))
        path.addLine(to: CGPoint(x: endX - arrowSize, y: topY + arrowSize * 0.6))
        
        return path
    }
}

// MARK: - 3. 最終渲染的視圖 (View)

// 利用 ZStack 把粗底線與細箭頭疊起來
struct SquareShapeWithArrows: View {
    var lineWidth: CGFloat = 60
    
    var body: some View {
        ZStack {
            // 第 1 層：底層粗灰方形
            // 這裡使用預設的 lineJoin (.miter) 讓方形的四個角保持直角銳利
            SquareShape(currentLineWidth: lineWidth)
                .stroke(
                    Color.gray.opacity(0.3),
                    style: StrokeStyle(lineWidth: lineWidth)
                )
            
            // 第 2 層：上層細白箭頭
            SquareArrowsShape(currentLineWidth: lineWidth)
                .stroke(
                    Color.white,
                    style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round)
                )
        }
        .padding() // 給予外圍緩衝空間避免被裁切
    }
}

// 預覽
#Preview {
    SquareShapeWithArrows(lineWidth: 60)
        .frame(width: 300, height: 300)
}
