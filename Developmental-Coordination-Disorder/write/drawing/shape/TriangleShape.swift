//
//  TriangleShape.swift
//  write
//
//  Created by 李天 on 2026/3/13.
//

import SwiftUI

// MARK: - 1. 底層基礎圖形 (粗灰線)

// 4. 三角形
struct TriangleShape: Shape {
    var currentLineWidth: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let dynamicPadding: CGFloat = (currentLineWidth / 2) + 10
        let top = CGPoint(x: rect.midX, y: rect.minY + dynamicPadding)
        let bottomRight = CGPoint(x: rect.maxX - dynamicPadding, y: rect.maxY - dynamicPadding)
        let bottomLeft = CGPoint(x: rect.minX + dynamicPadding, y: rect.maxY - dynamicPadding)
        
        path.move(to: top)
        path.addLine(to: bottomRight)
        path.addLine(to: bottomLeft)
        path.closeSubpath()
        return path
    }
}


// MARK: - 2. 上層箭頭圖形 (細白線)

// 三角形專用的箭頭
struct TriangleArrowsShape: Shape {
    var currentLineWidth: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let dynamicPadding: CGFloat = (currentLineWidth / 2) + 10
        let top = CGPoint(x: rect.midX, y: rect.minY + dynamicPadding)
        let bottomRight = CGPoint(x: rect.maxX - dynamicPadding, y: rect.maxY - dynamicPadding)
        
        // 畫在右側斜邊上，從上往下指 (起點抓在線段的 15%，終點抓在 40%)
        let startT: CGFloat = 0.15
        let endT: CGFloat = 0.40
        
        let startX = top.x + startT * (bottomRight.x - top.x)
        let startY = top.y + startT * (bottomRight.y - top.y)
        let endX = top.x + endT * (bottomRight.x - top.x)
        let endY = top.y + endT * (bottomRight.y - top.y)
        
        let startPoint = CGPoint(x: startX, y: startY)
        let endPoint = CGPoint(x: endX, y: endY)
        
        // 畫箭頭身體
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        
        // 計算斜邊的實際角度
        let angle = atan2(bottomRight.y - top.y, bottomRight.x - top.x)
        let arrowSize: CGFloat = 16
        let wingAngle: CGFloat = .pi / 6 // 30度
        
        // 計算左翼座標
        let leftWingAngle = angle + .pi - wingAngle
        let leftWing = CGPoint(
            x: endPoint.x + arrowSize * cos(leftWingAngle),
            y: endPoint.y + arrowSize * sin(leftWingAngle)
        )
        
        // 計算右翼座標
        let rightWingAngle = angle + .pi + wingAngle
        let rightWing = CGPoint(
            x: endPoint.x + arrowSize * cos(rightWingAngle),
            y: endPoint.y + arrowSize * sin(rightWingAngle)
        )
        
        // 畫箭頭兩翼
        path.move(to: leftWing)
        path.addLine(to: endPoint)
        path.addLine(to: rightWing)
        
        return path
    }
}


// MARK: - 3. 最終渲染的視圖 (View)

// 利用 ZStack 把粗底線與細箭頭疊起來
struct TriangleShapeWithArrows: View {
    var lineWidth: CGFloat = 60
    
    var body: some View {
        ZStack {
            // 第 1 層：底層粗灰三角形
            TriangleShape(currentLineWidth: lineWidth)
                .stroke(
                    Color.gray.opacity(0.3),
                    // 使用 .round 可以避免線條太粗時頂點被裁切得太銳利
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round)
                )
            
            // 第 2 層：上層細白箭頭
            TriangleArrowsShape(currentLineWidth: lineWidth)
                .stroke(
                    Color.white,
                    style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round)
                )
        }
        .padding() // 給予外圍緩衝空間
    }
}

// 預覽
#Preview {
    TriangleShapeWithArrows(lineWidth: 60)
        .frame(width: 300, height: 300)
}
