//
//  WriteAlgorithm.swift
//  write
//
//  Created by 李天 on 2026/3/19.
//

import Foundation
import CoreGraphics

// 1. 定義單一「觸控點」的資料
struct TouchPoint {
    let point: CGPoint
    let force: CGFloat
    let timestamp: TimeInterval
}

// 2. 定義「一筆劃」的結構，並內建分析演算法
struct Stroke {
    var points: [TouchPoint] = []
    
    // 取得平均壓力
    var averagePressure: CGFloat {
        guard !points.isEmpty else { return 0 }
        let totalPressure = points.reduce(0) { $0 + $1.force }
        return totalPressure / CGFloat(points.count)
    }
    
    // 取得平均速度 (點的單位距離 / 秒)
    var averageSpeed: CGFloat {
        guard points.count >= 2 else { return 0 }
        
        var totalDistance: CGFloat = 0
        for i in 0..<(points.count - 1) {
            let p1 = points[i].point
            let p2 = points[i+1].point
            // 計算歐式距離
            let dx = p2.x - p1.x
            let dy = p2.y - p1.y
            totalDistance += sqrt(dx*dx + dy*dy)
        }
        
        let totalTime = points.last!.timestamp - points.first!.timestamp
        guard totalTime > 0 else { return 0 }
        
        return totalDistance / CGFloat(totalTime)
    }
    
    // 取得方向改變次數
    func directionChangeCount(thresholdDegrees: CGFloat = 45.0) -> Int {
        guard points.count >= 3 else { return 0 }
        
        var changes = 0
        var previousAngle: CGFloat? = nil
        let thresholdRadians = thresholdDegrees * .pi / 180.0
        
        for i in 0..<(points.count - 1) {
            let p1 = points[i].point
            let p2 = points[i+1].point
            
            let dx = p2.x - p1.x
            let dy = p2.y - p1.y
            
            // 如果兩點距離太近（雜訊或停頓），跳過不算
            if sqrt(dx*dx + dy*dy) < 1.0 { continue }
            
            // 計算當前移動向量的角度 (atan2)
            let currentAngle = atan2(dy, dx)
            
            if let prev = previousAngle {
                // 計算角度差，並將其正規化到 0 ~ π 之間
                var angleDifference = abs(currentAngle - prev)
                if angleDifference > .pi {
                    angleDifference = 2 * .pi - angleDifference
                }
                
                // 如果角度變化大於閾值，判定為方向改變
                if angleDifference > thresholdRadians {
                    changes += 1
                }
            }
            previousAngle = currentAngle
        }
        
        return changes
    }
    
    var segmentSpeeds: [CGFloat] {
        guard points.count >= 2 else { return [] }
        
        var speeds: [CGFloat] = []
        for i in 0..<(points.count - 1) {
            let p1 = points[i]
            let p2 = points[i+1]
            
            let dx = p2.point.x - p1.point.x
            let dy = p2.point.y - p1.point.y
            let distance = sqrt(dx*dx + dy*dy)
            let dt = p2.timestamp - p1.timestamp
            
            // 避免除以零的防呆
            if dt > 0 {
                speeds.append(distance / CGFloat(dt))
            }
        }
        return speeds
    }
}
