//
//  CrossShape.swift
//  write
//
//  Created by 李天 on 2026/3/13.
//

//
//  CrossShape.swift
//  write
//
//  Created by 李天 on 2026/3/13.
//

import SwiftUI

// MARK: - 1. 底層基礎圖形 (粗灰線)

// 1. 十字線
struct CrossShape: Shape {
    var currentLineWidth: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let dynamicPadding: CGFloat = (currentLineWidth / 2) + 10
        
        // 畫垂直線
        path.move(to: CGPoint(x: rect.midX, y: rect.minY + dynamicPadding))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY - dynamicPadding))
        
        // 畫水平線
        path.move(to: CGPoint(x: rect.minX + dynamicPadding, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX - dynamicPadding, y: rect.midY))
        
        return path
    }
}

// MARK: - 2. 上層箭頭圖形 (細白線)

// 十字線專用的箭頭
struct CrossArrowsShape: Shape {
    var currentLineWidth: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let dynamicPadding: CGFloat = (currentLineWidth / 2) + 10
        let safeRect = rect.insetBy(dx: dynamicPadding, dy: dynamicPadding)
        let arrowSize: CGFloat = 16
        
        // 1. 垂直線箭頭 (往下指，畫在中心偏上半段)
        let vStartX = safeRect.midX
        let vStartY = safeRect.minY + safeRect.height * 0.1
        let vEndY = safeRect.minY + safeRect.height * 0.35
        
        path.move(to: CGPoint(x: vStartX, y: vStartY))
        path.addLine(to: CGPoint(x: vStartX, y: vEndY))
        // 箭頭兩翼
        path.move(to: CGPoint(x: vStartX - arrowSize * 0.6, y: vEndY - arrowSize))
        path.addLine(to: CGPoint(x: vStartX, y: vEndY))
        path.addLine(to: CGPoint(x: vStartX + arrowSize * 0.6, y: vEndY - arrowSize))
        
        // 2. 水平線箭頭 (往右指，畫在中心偏左半段)
        let hStartY = safeRect.midY
        let hStartX = safeRect.minX + safeRect.width * 0.1
        let hEndX = safeRect.minX + safeRect.width * 0.35
        
        path.move(to: CGPoint(x: hStartX, y: hStartY))
        path.addLine(to: CGPoint(x: hEndX, y: hStartY))
        // 箭頭兩翼
        path.move(to: CGPoint(x: hEndX - arrowSize, y: hStartY - arrowSize * 0.6))
        path.addLine(to: CGPoint(x: hEndX, y: hStartY))
        path.addLine(to: CGPoint(x: hEndX - arrowSize, y: hStartY + arrowSize * 0.6))
        
        return path
    }
}

// MARK: - 3. 最終渲染的視圖 (View)

// 利用 ZStack 把粗底線與細箭頭疊起來
struct CrossShapeWithArrows: View {
    var lineWidth: CGFloat = 60
    
    var body: some View {
        ZStack {
            // 第 1 層：底層粗灰線
            CrossShape(currentLineWidth: lineWidth)
                .stroke(
                    Color.gray.opacity(0.3),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round)
                )
            
            // 第 2 層：上層細白箭頭
            CrossArrowsShape(currentLineWidth: lineWidth)
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
    CrossShapeWithArrows(lineWidth: 60)
        .frame(width: 300, height: 300)
}
