//
//  homeView.swift
//  write
//
//  Created by 李天 on 2026/3/17.
//

import SwiftUI

struct writeHomeView: View {
    @StateObject var vm = shapeViewModel()
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            ZStack {
                Image("background_WriteHome")
                    .resizable()
                    .ignoresSafeArea()
                    .navigationBarBackButtonHidden(true)
                ZStack(alignment: .top){
                    // 白色漸層
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.white, Color.white.opacity(0.0)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 1000, height: 100)
                        .offset(y: 75)
                        .allowsHitTesting(false)
                    // 加入垂直滾動視圖
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        // 將地圖與關卡按鈕疊在一起
                        ZStack {
                            // 直向地圖照片
                            Image("map")
                                .resizable()
                                .scaledToFit()
                            
                            // 關卡按鈕
                            VStack(spacing: 10) {
                                ForEach(vm.levels) { level in
                                    NavigationLink(destination: missionView(shape: level.shape)) {
                                        Image("Level\(level.levelNumber)")
                                            .resizable()
                                            .frame(width: 140 , height: 140)
                                    }
                                    .offset(getLevelOffset(for: level.levelNumber))
                                }
                                Button{
                                    
                                }label: {
                                    Image("Level9")
                                        .resizable()
                                        .frame(width: 210 , height: 190)
                                        .offset(x: 50 , y: -200)
                                }
                            }
                        }
                    }
                    .frame(width: 1000 , height: 670)
                    .offset(y: 75)
                }
                Button {
                    dismiss()
                } label:{
                    Image("Element-Backbutton")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100 , height: 100)
                }
                .offset(x: -480 , y: -320)
            }
        }
    }
    // 根據關卡編號回傳對應的 X, Y 偏移量
    func getLevelOffset(for levelNumber: Int) -> CGSize {
        switch levelNumber {
        case 1: return CGSize(width: -280, height: 240)  // 最底下靠左
        case 2: return CGSize(width:  0, height: 110)  // 往右上偏
        case 3: return CGSize(width:  250, height: 100)  // 更靠右
        case 4: return CGSize(width:   120, height: 80)  // 繞回中間
        case 5: return CGSize(width: -100, height: -70) // 偏左上
        case 6: return CGSize(width: -330, height: -110) // 繼續往上
        case 7: return CGSize(width:  -50, height: -110) // 最頂部靠右
        case 8: return CGSize(width:  200, height: -170) // 最頂部靠右
        default: return CGSize(width: 0, height: 0)
        }
    }
}

#Preview {
    writeHomeView()
}
