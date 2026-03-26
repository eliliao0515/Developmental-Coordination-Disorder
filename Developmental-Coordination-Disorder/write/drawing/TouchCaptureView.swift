//
//  TouchCaptureView.swift
//  write
//
//  Created by 李天 on 2026/3/10.
//

// MARK: - 底層 UIKit 觸控攔截器
import SwiftUI
import UIKit
// MARK: - 2. 底層 UIKit 觸控攔截器
class TouchCatcherView: UIView {
    // 當捕捉到移動時，透過這個閉包將資料往外傳 (起點, 終點, 壓力值)
    var onDraw: ((CGPoint, CGPoint, CGFloat) -> Void)?
    var onStrokeEnd: ((Stroke) -> Void)?
    private var lastPoint: CGPoint?
    
    // 儲存當前筆劃的數據
    private var currentStroke = Stroke()
    
    private var strokeCounter: Int = 0
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.isMultipleTouchEnabled = false // 關閉多點觸控
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        guard touch.type == .pencil else { return }
        
        lastPoint = touch.location(in: self)
        
        // 初始化新筆劃並記錄第一點
        currentStroke = Stroke()
        let pointData = TouchPoint(point: touch.location(in: self), force: touch.force, timestamp: touch.timestamp)
        currentStroke.points.append(pointData)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let last = lastPoint else { return }
        guard touch.type == .pencil else { return }
        
        let currentPoint = touch.location(in: self)
        let force = touch.force
        
        // 紀錄移動過程中的每一個點
        let pointData = TouchPoint(point: currentPoint, force: force, timestamp: touch.timestamp)
        currentStroke.points.append(pointData)
        
        // 觸發閉包，讓 SwiftUI 畫線
        onDraw?(last, currentPoint, force)
        lastPoint = currentPoint
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        guard touch.type == .pencil else { return }
        
        // 紀錄最後一個抬起點
        let pointData = TouchPoint(point: touch.location(in: self), force: touch.force, timestamp: touch.timestamp)
        currentStroke.points.append(pointData)
        
        // 結算基本數據
        let avgPressure = currentStroke.averagePressure
        let directionChanges = currentStroke.directionChangeCount(thresholdDegrees: 45)
        
        strokeCounter += 1
        print("\n === 第 \(strokeCounter) 筆劃分析完成 ===")
        print("總取樣點數: \(currentStroke.points.count) 個點")
        print("平均壓力: \(String(format: "%.2f", avgPressure))")
        print("方向改變次數: \(directionChanges) 次")
        
        // 針對「這單一筆劃」計算最高速、最低速與中位數
        let segmentSpeeds = currentStroke.segmentSpeeds
        if !segmentSpeeds.isEmpty {
            // 1. 先排序
            let sortedSpeeds = segmentSpeeds.sorted()
            let totalCount = sortedSpeeds.count
            
            // 2. 計算要砍掉的最慢 10% 數量
            let dropRatio: CGFloat = 0.10
            let dropCount = Int(CGFloat(totalCount) * dropRatio)
            
            // 3. 建立「過濾後的新陣列」
            let trimmedSpeeds: [CGFloat]
            if totalCount > (dropCount * 2) && dropCount > 0 {
                trimmedSpeeds = Array(sortedSpeeds.dropFirst(dropCount).dropLast(dropCount))
            } else {
                trimmedSpeeds = sortedSpeeds
            }
            
            let trimmedCount = trimmedSpeeds.count
            
            // 4. 全部都從「過濾後的新陣列」來取值與計算
            let maxSpeed = trimmedSpeeds.last!
            let minSpeed = trimmedSpeeds.first!
            
            // 修正：將計算好的過濾平均值存入變數
            let trimmedAvgSpeed = trimmedSpeeds.reduce(0, +) / CGFloat(trimmedCount)
            
            // 計算過濾後的中位數
            let medianSpeed: CGFloat
            if trimmedCount % 2 == 0 {
                let midRight = trimmedCount / 2
                let midLeft = midRight - 1
                medianSpeed = (trimmedSpeeds[midLeft] + trimmedSpeeds[midRight]) / 2.0
            } else {
                medianSpeed = trimmedSpeeds[trimmedCount / 2]
            }
            
            print("[速度詳細統計]")
            print("最高速 : \(String(format: "%.2f", maxSpeed)) pts/sec")
            print("最低速 : \(String(format: "%.2f", minSpeed)) pts/sec")
            print("平均速 : \(String(format: "%.2f", trimmedAvgSpeed)) pts/sec")
            print("中位數 : \(String(format: "%.2f", medianSpeed)) pts/sec")
            print("-------------------")
        }
        
        
        let speedScore = ScoreEvaluator.scoreForSpeed(strokes: [currentStroke])
        let pressureScore = ScoreEvaluator.scoreForPressure(strokes: [currentStroke])
        let directionScore = ScoreEvaluator.scoreForDirectionChanges(directionChanges)
        
        print("[單筆評分結果]")
        print("速度得分 : \(speedScore) 分")
        print("壓力得分 : \(pressureScore) 分")
        print("方向改變 : \(directionScore) 分")
        print("==================================\n")
        
        onStrokeEnd?(currentStroke)
        lastPoint = nil
    }
}

// MARK: - 3. SwiftUI 橋接封裝器
struct TouchCaptureRepresentable: UIViewRepresentable {
    @ObservedObject var manager: DrawingManager
    
    func makeUIView(context: Context) -> TouchCatcherView {
        let view = TouchCatcherView()
        view.onDraw = { start, end, force in
            DispatchQueue.main.async {
                let segment = ColoredSegment(startPoint: start, endPoint: end, force: force)
                manager.segments.append(segment)
            }
        }
        
        view.onStrokeEnd = { completedStroke in
            DispatchQueue.main.async {
                manager.allStrokes.append(completedStroke)
            }
        }
        return view
    }
    
    func updateUIView(_ uiView: TouchCatcherView, context: Context) {}
}

#Preview {
    TouchCaptureRepresentable(manager: DrawingManager())
        .background(Color.gray.opacity(0.1))
}
