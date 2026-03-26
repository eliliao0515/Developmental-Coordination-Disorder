//
//  missionView.swift
//  write
//
//  Created by 李天 on 2026/3/6.
//

import SwiftUI

struct missionView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var drawingManager = DrawingManager()
    @State var isExpendedGoal: Bool = true
    @State var isExpendedPlan: Bool = false
    @State var isExpendedDo: Bool = false
    @State var isExpendedExplain: Bool = false
    @State var shape: String
    
    // 控制結算視窗的顯示狀態與最終分數
    @State private var showResultOverlay: Bool = false
    @State private var finalScore: Int = 0
    
    var body: some View {
        ZStack {
            // MARK: - 底層主畫面
            Image("background_Write")
                .resizable()
                .scaledToFill()
            
            Image("paper")
                .resizable()
                .frame(width: 1000 , height: 680)
                .navigationBarBackButtonHidden(true)
            
            HStack(spacing: 20) {
                Spacer()
                PressureCanvasView(drawingManager: drawingManager, shape: shape)
                Spacer()
                VStack(alignment: .leading , spacing: 20) {
                    textareaView(isExpendedGoal: $isExpendedGoal, isExpendedPlan: $isExpendedPlan, isExpendedDo: $isExpendedDo, isExpendedExplain: $isExpendedExplain)
                }
                .frame(width: 350 , height: 500)
                Spacer()
            }
            .frame(width: 900 , height: 500)
            
            // 左上返回鍵，不計分
            Button {
                dismiss()
            } label:{
                Image("Element-Backbutton")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100 , height: 100)
            }
            .offset(x: -480 , y: -320)
            
            // MARK: - 右下結束鍵
            Button {
                // 1. 呼叫評分器計算總分
                if let report = ScoreEvaluator.evaluateLevel(strokes: drawingManager.allStrokes) {
                    self.finalScore = report.overallScore
                    
                    // 在 Console 印出這關的總得分
                    print("\n🏁 [關卡結算完成]")
                    print("總時間 ： \(report.totalDuration)秒")
                    print("總方向改變次數 ： \(report.totalDirectionChanges)次")
                    print("速度總評 : \(report.speedScore) 分")
                    print("壓力總評 : \(report.pressureScore) 分")
                    print("方向總評 : \(report.directionScore) 分")
                    print("🎉 最終關卡總分 : \(report.overallScore) 分")
                    print("==================================\n")
                    
                    // 2. 打開結算視窗
                    withAnimation(.spring()) {
                        self.showResultOverlay = true
                    }
                } else {
                    print("使用者還沒畫任何東西！")
                    dismiss()
                }
            } label: {
                ZStack {
                    Image("Element-CheckButton")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100 , height: 100)
                }
            }
            .offset(x: 500 , y: 300)
            .ignoresSafeArea()
            
            // MARK: -彈出結算視窗
            if showResultOverlay {
                ZStack {
                    // 1. 半透明黑色背景
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                    
                    // 2. 依照分數呼叫 View
                    Group {
                        if finalScore >= 85 {
                            perfectView()
                        } else if finalScore >= 70 {
                            goodView()
                        } else if finalScore >= 60 {
                            normalView()
                        } else {
                            badView()
                        }
                    }
                }
                .onTapGesture {
                    dismiss() // 點擊任意處退出
                }
                .zIndex(100)
            }
        }
    }
}

#Preview {
    NavigationStack {
        missionView(shape: "Cross")
    }
}
