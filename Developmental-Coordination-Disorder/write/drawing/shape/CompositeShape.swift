//
//  CompositeShape.swift
//  write
//
//  Created by 李天 on 2026/3/13.
//

import SwiftUI

// MARK: - 1. 基礎圖形 (底層粗線)

// 1. 十字線 (加上 Comp 前綴避免與外部檔案衝突)
struct CompCrossShape: Shape {
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

// 2. 圓形 (加上 Comp 前綴避免與外部檔案衝突)
struct CompCircleShape: Shape {
    var currentLineWidth: CGFloat
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let dynamicPadding: CGFloat = (currentLineWidth / 2) + 10
        let safeRect = rect.insetBy(dx: dynamicPadding, dy: dynamicPadding)
        path.addEllipse(in: safeRect)
        return path
    }
}

// 3. 方形 (加上 Comp 前綴避免與外部檔案衝突)
struct CompSquareShape: Shape {
    var currentLineWidth: CGFloat
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let dynamicPadding: CGFloat = (currentLineWidth / 2) + 10
        let safeRect = rect.insetBy(dx: dynamicPadding, dy: dynamicPadding)
        path.addRect(safeRect)
        return path
    }
}

// 4. 將三個形狀合併成一個複合圖形
struct CompositeShape: Shape {
    var currentLineWidth: CGFloat
    var innerInset: CGFloat = 120.0
    func path(in rect: CGRect) -> Path {
        var combinedPath = Path()
        
        // 這裡改呼叫更新名稱後的 CompCircleShape
        combinedPath.addPath(CompCircleShape(currentLineWidth: currentLineWidth).path(in: rect))
        
        let innerRect = rect.insetBy(dx: innerInset, dy: innerInset)
        
        // 這裡改呼叫更新名稱後的 CompSquareShape 與 CompCrossShape
        combinedPath.addPath(CompSquareShape(currentLineWidth: currentLineWidth).path(in: innerRect))
        combinedPath.addPath(CompCrossShape(currentLineWidth: currentLineWidth).path(in: innerRect))
        
        return combinedPath
    }
}


// MARK: - 2. 箭頭圖形 (上層細白線)

// 圓形專用的順時針箭頭
struct CompCircleArrowsShape: Shape {
    var currentLineWidth: CGFloat
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let dynamicPadding: CGFloat = (currentLineWidth / 2) + 10
        let safeRect = rect.insetBy(dx: dynamicPadding, dy: dynamicPadding)
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(safeRect.width, safeRect.height) / 2
        
        let startAngle = Angle(degrees: -90)
        let endAngle = Angle(degrees: -30)
        
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        let endX = center.x + radius * cos(CGFloat(endAngle.radians))
        let endY = center.y + radius * sin(CGFloat(endAngle.radians))
        let endPoint = CGPoint(x: endX, y: endY)
        
        let tangentAngle = CGFloat(endAngle.radians) + .pi / 2
        let arrowSize: CGFloat = 16
        let wingAngle: CGFloat = .pi / 6
        
        let leftWingAngle = tangentAngle + .pi - wingAngle
        let leftWing = CGPoint(x: endPoint.x + arrowSize * cos(leftWingAngle), y: endPoint.y + arrowSize * sin(leftWingAngle))
        
        let rightWingAngle = tangentAngle + .pi + wingAngle
        let rightWing = CGPoint(x: endPoint.x + arrowSize * cos(rightWingAngle), y: endPoint.y + arrowSize * sin(rightWingAngle))
        
        path.move(to: leftWing)
        path.addLine(to: endPoint)
        path.addLine(to: rightWing)
        
        return path
    }
}

// 方形專用的箭頭
struct CompSquareArrowsShape: Shape {
    var currentLineWidth: CGFloat
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let dynamicPadding: CGFloat = (currentLineWidth / 2) + 10
        let safeRect = rect.insetBy(dx: dynamicPadding, dy: dynamicPadding)
        let arrowSize: CGFloat = 16
        
        let topY = safeRect.minY
        let startX = safeRect.minX + safeRect.width * 0.15
        let endX = safeRect.minX + safeRect.width * 0.4
        
        path.move(to: CGPoint(x: startX, y: topY))
        path.addLine(to: CGPoint(x: endX, y: topY))
        
        path.move(to: CGPoint(x: endX - arrowSize, y: topY - arrowSize * 0.6))
        path.addLine(to: CGPoint(x: endX, y: topY))
        path.addLine(to: CGPoint(x: endX - arrowSize, y: topY + arrowSize * 0.6))
        
        return path
    }
}

// 十字線專用的箭頭
struct CompCrossArrowsShape: Shape {
    var currentLineWidth: CGFloat
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let dynamicPadding: CGFloat = (currentLineWidth / 2) + 10
        let safeRect = rect.insetBy(dx: dynamicPadding, dy: dynamicPadding)
        let arrowSize: CGFloat = 16
        
        // 垂直線箭頭 (往下)
        let vStartX = safeRect.midX
        let vStartY = safeRect.minY + safeRect.height * 0.1
        let vEndY = safeRect.minY + safeRect.height * 0.35
        
        path.move(to: CGPoint(x: vStartX, y: vStartY))
        path.addLine(to: CGPoint(x: vStartX, y: vEndY))
        path.move(to: CGPoint(x: vStartX - arrowSize * 0.6, y: vEndY - arrowSize))
        path.addLine(to: CGPoint(x: vStartX, y: vEndY))
        path.addLine(to: CGPoint(x: vStartX + arrowSize * 0.6, y: vEndY - arrowSize))
        
        // 水平線箭頭 (往右)
        let hStartY = safeRect.midY
        let hStartX = safeRect.minX + safeRect.width * 0.1
        let hEndX = safeRect.minX + safeRect.width * 0.35
        
        path.move(to: CGPoint(x: hStartX, y: hStartY))
        path.addLine(to: CGPoint(x: hEndX, y: hStartY))
        path.move(to: CGPoint(x: hEndX - arrowSize, y: hStartY - arrowSize * 0.6))
        path.addLine(to: CGPoint(x: hEndX, y: hStartY))
        path.addLine(to: CGPoint(x: hEndX - arrowSize, y: hStartY + arrowSize * 0.6))
        
        return path
    }
}

// 將三個箭頭形狀合併的複合箭頭 Shape
struct CompositeArrowsShape: Shape {
    var currentLineWidth: CGFloat
    var innerInset: CGFloat = 120.0
    func path(in rect: CGRect) -> Path {
        var combinedPath = Path()
        combinedPath.addPath(CompCircleArrowsShape(currentLineWidth: currentLineWidth).path(in: rect))
        
        let innerRect = rect.insetBy(dx: innerInset, dy: innerInset)
        combinedPath.addPath(CompSquareArrowsShape(currentLineWidth: currentLineWidth).path(in: innerRect))
        combinedPath.addPath(CompCrossArrowsShape(currentLineWidth: currentLineWidth).path(in: innerRect))
        
        return combinedPath
    }
}


// MARK: - 3. 最終渲染的視圖 (View)

// 利用 ZStack 把粗底線與細箭頭疊起來
struct CompositeShapeWithArrows: View {
    var lineWidth: CGFloat = 60
    var innerInset: CGFloat = 120.0
    
    var body: some View {
        ZStack {
            // 第 1 層：底層粗灰線
            CompositeShape(currentLineWidth: lineWidth, innerInset: innerInset)
                .stroke(
                    Color.gray.opacity(0.3),
                    style: StrokeStyle(lineWidth: lineWidth)
                )
            
            // 第 2 層：上層細白箭頭
            CompositeArrowsShape(currentLineWidth: lineWidth, innerInset: innerInset)
                .stroke(
                    Color.white,
                    style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round)
                )
        }
        .padding()
    }
}

// 預覽
#Preview {
    CompositeShapeWithArrows(lineWidth: 60)
        .frame(width: 500, height: 500)
}
