//
//  Bu.swift
//  write
//
//  Created by 李天 on 2026/3/13.
//

import SwiftUI

// 1. 底層的「不」字 Shape (維持你原本的邏輯)
struct BuShape: Shape {
    var currentLineWidth: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let dynamicPadding: CGFloat = (currentLineWidth / 2) + 10
        
        let startX = rect.minX + dynamicPadding
        let endX = rect.maxX - dynamicPadding
        let startY = rect.minY + dynamicPadding
        let endY = rect.maxY - dynamicPadding
        
        let width = endX - startX
        let height = endY - startY
        
        // 橫
        let hengY = startY + height * 0.2
        let hengStartX = startX + width * 0.10
        let hengEndX = endX - width * 0.10
        path.move(to: CGPoint(x: hengStartX, y: hengY))
        path.addLine(to: CGPoint(x: hengEndX, y: hengY))
        
        // 撇
        let pieStartX = rect.midX
        let pieStartY = hengY
        let pieEndX = startX + width * 0.1
        let pieEndY = startY + height * 0.75
        let controlX = rect.midX - width * 0.15
        let controlY = startY + height * 0.5
        path.move(to: CGPoint(x: pieStartX, y: pieStartY))
        path.addQuadCurve(to: CGPoint(x: pieEndX, y: pieEndY), control: CGPoint(x: controlX, y: controlY))
        
        // 豎
        let shuStartX = rect.midX
        let shuStartY = hengY
        let shuEndY = endY
        path.move(to: CGPoint(x: shuStartX, y: shuStartY))
        path.addLine(to: CGPoint(x: shuStartX, y: shuEndY))
        
        // 點
        let dianStartX = rect.midX
        let dianStartY = startY + height * 0.45
        let dianEndX = endX - width * 0.1
        let dianEndY = startY + height * 0.75
        path.move(to: CGPoint(x: dianStartX, y: dianStartY))
        path.addLine(to: CGPoint(x: dianEndX, y: dianEndY))
        
        return path
    }
}

// 2. 專門負責畫「白色箭頭」的 Shape
struct BuArrowsShape: Shape {
    var currentLineWidth: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let dynamicPadding: CGFloat = (currentLineWidth / 2) + 10
        let startX = rect.minX + dynamicPadding
        let endX = rect.maxX - dynamicPadding
        let startY = rect.minY + dynamicPadding
        let endY = rect.maxY - dynamicPadding
        
        let width = endX - startX
        let height = endY - startY
        
        // 設定箭頭頭部的尺寸
        let arrowSize: CGFloat = 12
        let hengY = startY + height * 0.2
        
        // --- 第一個箭頭：橫向 (向右) ---
        let arrow1Start = CGPoint(x: startX + width * 0.2, y: hengY)
        let arrow1End = CGPoint(x: startX + width * 0.35, y: hengY)
        
        path.move(to: arrow1Start)
        path.addLine(to: arrow1End)
        // 畫箭頭的上下兩翼
        path.move(to: CGPoint(x: arrow1End.x - arrowSize, y: arrow1End.y - arrowSize * 0.6))
        path.addLine(to: arrow1End)
        path.addLine(to: CGPoint(x: arrow1End.x - arrowSize, y: arrow1End.y + arrowSize * 0.6))
        
        // --- 第二個箭頭：撇向 (向左下) ---
        // 抓弧線前半段的路徑
        let arrow2Start = CGPoint(x: rect.midX - width * 0.05, y: hengY + height * 0.1)
        let arrow2End = CGPoint(x: rect.midX - width * 0.18, y: hengY + height * 0.26)
        
        path.move(to: arrow2Start)
        path.addLine(to: arrow2End)
        // 畫箭頭的兩翼 (依照左下角度計算相對偏移)
        path.move(to: CGPoint(x: arrow2End.x + arrowSize * 0.2, y: arrow2End.y - arrowSize))
        path.addLine(to: arrow2End)
        path.addLine(to: CGPoint(x: arrow2End.x + arrowSize, y: arrow2End.y - arrowSize * 0.2))
        
        return path
    }
}

#Preview {
    BuShape(currentLineWidth: 60)
}
