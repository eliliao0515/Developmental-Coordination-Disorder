//
//  CircleView.swift
//  write
//
//  Created by 李天 on 2026/3/13.
//

import SwiftUI

// 1. 底層：原本的圓形
struct CircleShape: Shape {
    var currentLineWidth: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let dynamicPadding: CGFloat = (currentLineWidth / 2) + 10
        
        // 直接產生一個向內縮小 dynamicPadding 的安全矩形
        let safeRect = rect.insetBy(dx: dynamicPadding, dy: dynamicPadding)
        
        // 在安全矩形內畫橢圓（長寬一樣就會是正圓）
        path.addEllipse(in: safeRect)
        
        return path
    }
}

// 2. 上層：負責畫出順時針弧形箭頭
struct CircleArrowsShape: Shape {
    var currentLineWidth: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let dynamicPadding: CGFloat = (currentLineWidth / 2) + 10
        let safeRect = rect.insetBy(dx: dynamicPadding, dy: dynamicPadding)
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        // 確保半徑不受長方形影響，取最短邊的一半
        let radius = min(safeRect.width, safeRect.height) / 2
        
        // --- 設定箭頭的起點與終點角度 ---
        // 在 iOS 座標系中 (Y軸向下)，0 度在 3 點鐘方向。
        // 我們從 12 點鐘方向 (-90度) 畫到約 2點鐘方向 (-30度)
        let startAngle = Angle(degrees: -90)
        let endAngle = Angle(degrees: -30)
        
        // 畫出順著圓形軌跡的弧線身體
        // 注意：SwiftUI 的 addArc 中，clockwise: false 在畫面上看起來是順時針
        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )
        
        // --- 畫箭頭的頭部 (兩翼) ---
        // 計算終點座標
        let endX = center.x + radius * cos(CGFloat(endAngle.radians))
        let endY = center.y + radius * sin(CGFloat(endAngle.radians))
        let endPoint = CGPoint(x: endX, y: endY)
        
        // 計算終點的切線角度 (順時針圓的切線 = 該點角度 + 90度)
        let tangentAngle = CGFloat(endAngle.radians) + .pi / 2
        
        let arrowSize: CGFloat = 16
        let wingAngle: CGFloat = .pi / 6 // 30 度展開
        
        // 左翼：切線反方向 (-180度) 減去展開角
        let leftWingAngle = tangentAngle + .pi - wingAngle
        let leftWing = CGPoint(
            x: endPoint.x + arrowSize * cos(leftWingAngle),
            y: endPoint.y + arrowSize * sin(leftWingAngle)
        )
        
        // 右翼：切線反方向 (+180度) 加上展開角
        let rightWingAngle = tangentAngle + .pi + wingAngle
        let rightWing = CGPoint(
            x: endPoint.x + arrowSize * cos(rightWingAngle),
            y: endPoint.y + arrowSize * sin(rightWingAngle)
        )
        
        // 畫上左右兩翼
        path.move(to: leftWing)
        path.addLine(to: endPoint)
        path.addLine(to: rightWing)
        
        return path
    }
}

// 3. 將兩層疊加起來的 View
struct CircleShapeWithArrows: View {
    var lineWidth: CGFloat = 60
    
    var body: some View {
        ZStack {
            // 底層灰色粗圓
            CircleShape(currentLineWidth: lineWidth)
                .stroke(
                    Color.gray.opacity(0.3),
                    style: StrokeStyle(lineWidth: lineWidth)
                )
            
            // 上層白色細箭頭
            CircleArrowsShape(currentLineWidth: lineWidth)
                .stroke(
                    Color.white,
                    style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round)
                )
        }
        .padding() // 避免邊緣被裁切
    }
}

// 預覽
#Preview {
    CircleShapeWithArrows(lineWidth: 60)
        .frame(width: 300, height: 300)
}
