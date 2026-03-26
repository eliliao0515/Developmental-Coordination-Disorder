//
//  ScoreEvaluator.swift
//  write
//
//  Created by 李天 on 2026/3/19.
//

import Foundation
import CoreGraphics

// MARK: - 關卡結算資料結構
/// 用來打包整個關卡分數的資料結構，方便 ContentView 或 MissionView 呼叫使用
struct LevelScoreReport {
    let speedScore: Int
    let pressureScore: Int
    let directionScore: Int
    
    let totalDuration: Int// 該關卡所有筆畫的總花費秒數
    let totalDirectionChanges: Int  // 該關卡所有筆畫的總方向改變次數
    
    /// 整個關卡的總平均分數 (三項指標平均)
    var overallScore: Int {
        return (speedScore + pressureScore + directionScore) / 3
    }
}

/// 專門用來將筆劃物理量正規化為 100 分制的評分器
struct ScoreEvaluator {
    
    // MARK: - 1. 穩定度速度評分 (0 ~ 100，距離加權版)
    static func scoreForSpeed(strokes: [Stroke]) -> Int {
        // 宣告一個內部結構，用來綁定「速度」與「該速度維持的距離」
        struct SpeedSegment {
            let speed: CGFloat
            let distance: CGFloat
        }
        var segments: [SpeedSegment] = []
        
        // 1. 抽出所有的速度與距離
        for stroke in strokes {
            let points = stroke.points
            guard points.count >= 2 else { continue }
            
            for i in 0..<(points.count - 1) {
                let p1 = points[i]
                let p2 = points[i+1]
                
                let dx = p2.point.x - p1.point.x
                let dy = p2.point.y - p1.point.y
                let distance = sqrt(dx*dx + dy*dy)
                let timeDelta = p2.timestamp - p1.timestamp
                
                if timeDelta > 0 {
                    let speed = distance / CGFloat(timeDelta)
                    segments.append(SpeedSegment(speed: speed, distance: distance))
                }
            }
        }
        
        guard !segments.isEmpty else { return 0 }
        
        // 2. 依照速度大小排序，準備截尾
        segments.sort { $0.speed < $1.speed }
        let totalCount = segments.count
        
        let dropRatio: CGFloat = 0.10
        let dropCount = Int(CGFloat(totalCount) * dropRatio)
        
        let trimmedSegments: [SpeedSegment]
        if totalCount > (dropCount * 2) && dropCount > 0 {
            trimmedSegments = Array(segments.dropFirst(dropCount).dropLast(dropCount))
        } else {
            trimmedSegments = segments
        }
        
        // 3. 針對剩下的中間 80% 進行加權計分
        let lowerBound: CGFloat = 250.0
        let upperBound: CGFloat = 320.0
        let tolerance: CGFloat = 250.0
        
        var totalWeightedScore: CGFloat = 0.0
        var totalValidDistance: CGFloat = 0.0
        
        for seg in trimmedSegments {
            var pointScore: CGFloat = 0.0
            
            if seg.speed >= lowerBound && seg.speed <= upperBound {
                pointScore = 100.0
            } else if seg.speed < lowerBound {
                let diff = lowerBound - seg.speed
                pointScore = 100.0 - (diff / tolerance) * 100.0
            } else {
                let diff = seg.speed - upperBound
                pointScore = 100.0 - (diff / tolerance) * 100.0
            }
            
            let finalPointScore = max(0.0, pointScore)
            
            // 🌟 核心改變：分數 ✕ 距離 = 加權總分
            totalWeightedScore += (finalPointScore * seg.distance)
            totalValidDistance += seg.distance
        }
        
        guard totalValidDistance > 0 else { return 0 }
        
        // 總加權分數 ÷ 總長度 = 真實的視覺平均分數
        return Int(round(totalWeightedScore / totalValidDistance))
    }
    
    // MARK: - 2. 壓力比例評分 (0 ~ 100)
    static func scoreForPressure(strokes: [Stroke]) -> Int {
        var totalDistance: CGFloat = 0.0
        var normalDistance: CGFloat = 0.0
        
        for stroke in strokes {
            let points = stroke.points
            let count = points.count
            
            // 削去頭尾各 5% 的起落筆過渡期
            let dropRatio: CGFloat = 0.05
            let dropCount = Int(CGFloat(count) * dropRatio)
            
            let validPoints: [TouchPoint]
            if count > (dropCount * 2) && dropCount > 0 {
                validPoints = Array(points.dropFirst(dropCount).dropLast(dropCount))
            } else {
                validPoints = points
            }
            
            // 防呆：至少要有兩個點才能算距離
            guard validPoints.count >= 2 else { continue }
            
            // 🌟 核心改變：改算「線段長度」而不是「點數」
            for i in 0..<(validPoints.count - 1) {
                let p1 = validPoints[i]
                let p2 = validPoints[i+1]
                
                // 過濾殘影點：壓力小於 0.2 直接跳過
                guard p1.force >= 0.2 else { continue }
                
                // 計算 p1 到 p2 之間的物理距離 (畢氏定理)
                let dx = p2.point.x - p1.point.x
                let dy = p2.point.y - p1.point.y
                let distance = sqrt(dx*dx + dy*dy)
                
                totalDistance += distance
                
                // 檢查這個微小線段的起點壓力是否落在綠色區間 (0.9 ~ 2.1)
                if p1.force >= 0.9 && p1.force <= 2.1 {
                    normalDistance += distance
                }
            }
        }
        
        guard totalDistance > 0 else { return 0 }
        
        // 印出除錯資訊，你會發現這兩個數字現在完美對應你螢幕上看到的比例！
        print("[壓力除錯] 有效總長度: \(String(format: "%.1f", totalDistance)) | 綠色正常長度: \(String(format: "%.1f", normalDistance))")
        
        // 計算長度比例並轉換為 100 分制
        let ratio = (normalDistance / totalDistance) * 100.0
        return Int(round(ratio))
    }
    
    // MARK: - 3. 方向改變次數評分 (0 ~ 100)
    static func scoreForDirectionChanges(_ changes: Int) -> Int {
        // 每多出 1 次方向改變，扣 10 分
        let penaltyPerChange = 10
        let rawScore = 100 - (changes * penaltyPerChange)
        return max(0, rawScore)
    }
    
    // MARK: - 4. 關卡總結算邏輯
    static func evaluateLevel(strokes: [Stroke]) -> LevelScoreReport? {
        guard !strokes.isEmpty else { return nil }
        
        var totalDirectionScore = 0
        var totalDirectionChanges = 0
        // 先用 TimeInterval (Double) 累加，避免每次加總都遺失小數點的精確度
        var rawTotalDuration: TimeInterval = 0.0
        
        for stroke in strokes {
            // 1. 計算方向改變次數
            let strokeChanges = stroke.directionChangeCount(thresholdDegrees: 45)
            totalDirectionChanges += strokeChanges
            
            let strokeScore = scoreForDirectionChanges(strokeChanges)
            totalDirectionScore += strokeScore
            
            // 2. 計算該筆劃的花費時間並累加
            if let firstPoint = stroke.points.first, let lastPoint = stroke.points.last {
                let duration = lastPoint.timestamp - firstPoint.timestamp
                if duration > 0 {
                    rawTotalDuration += duration
                }
            }
        }
        
        // 算速度與壓力分數
        let speedScore = scoreForSpeed(strokes: strokes)
        let pressureScore = scoreForPressure(strokes: strokes)
        
        // 計算方向改變的平均分數
        let strokeCount = strokes.count
        let avgDirectionScore = totalDirectionScore / strokeCount
        
        // 將最終的總秒數四捨五入後，轉換為整數
        let finalDurationInt = Int(round(rawTotalDuration))
        
        // 打包成物件回傳給 UI 層
        return LevelScoreReport(
            speedScore: speedScore,
            pressureScore: pressureScore,
            directionScore: avgDirectionScore,
            totalDuration: finalDurationInt,
            totalDirectionChanges: totalDirectionChanges
        )
    }
}
