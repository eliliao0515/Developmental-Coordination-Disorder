//
//  BrianView.swift
//  DCDApp
//
//  Created by 訪客使用者 on 2026/3/20.
//

import SwiftUI
import AVFoundation

// 定義關卡的 enum
enum GameLevel {
    case level1
    case level2
}

struct RecognitionView: View {
    
    @State private var correctPopup: Bool = false
    @State private var errorPopup: Bool = false
    @State var audioPlayer: AVAudioPlayer?
    @State private var currentLevel: GameLevel = .level1

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                let w = geometry.size.width
                let h = geometry.size.height

                ZStack(alignment: .topLeading) {

                    // 根據關卡切換畫面
                    switch currentLevel {

                    case .level1:
                        levelOneView(w: w, h: h)

                    case .level2:
                        levelThreeView(w: w, h: h)
                    }

                    // 彈出視窗層（所有關卡共用）
                    if correctPopup || errorPopup {
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                            .onTapGesture {
                                handleTap()
                            }

                        VStack {
                            Spacer()
                            Image(correctPopup ? "Correct" : "Error")
                                .resizable()
                                .scaledToFit()
                                .frame(width: w * 0.8)
                                .cornerRadius(20)
                                .shadow(color: .black.opacity(0.3), radius: 20, x: 10, y: 10)
                                .transition(.scale)
                                .onTapGesture {
                                    handleTap()
                                }

                        
                            

                            Spacer()
                        }
                        .frame(width: w, height: h)
                    }
                }
            }
        }
    }

    // MARK: - Level 1 View
    @ViewBuilder
    func levelOneView(w: CGFloat, h: CGFloat) -> some View {
        Image("Visual Recognition")
            .resizable()
            .ignoresSafeArea()
            .scaledToFill()
            .frame(width: w, height: h)

        Button(action: { playSound(named: "Eli") }) {
            Image("Volumn")
                .resizable()
                .scaledToFit()
                .frame(width: w * 0.08, height: w * 0.08)
        }
        .offset(x: w * 0.74, y: h * 0.25)

        // 錯誤泡泡
        Button(action: { errorPopup = true }) {
            Image("First Bubble")
                .resizable()
                .scaledToFit()
                .frame(width: w * 0.185, height: w * 0.185)
                .clipShape(Circle())
        }
        .contentShape(Circle())
        .offset(x: w * 0.1, y: h * 0.6)

        Button(action: { errorPopup = true }) {
            Image("Second Bubble")
                .resizable()
                .scaledToFit()
                .frame(width: w * 0.25, height: w * 0.25)
                .clipShape(Circle())
        }
        .contentShape(Circle())
        .offset(x: w * 0.3, y: h * 0.43)

        Button(action: { errorPopup = true }) {
            Image("Fourth Bubble")
                .resizable()
                .scaledToFit()
                .frame(width: w * 0.25, height: w * 0.25)
                .clipShape(Circle())
        }
        .contentShape(Circle())
        .offset(x: w * 0.65, y: h * 0.43)

        // 正確答案
        Button(action: { correctPopup = true }) {
            Image("Third Bubble")
                .resizable()
                .scaledToFit()
                .frame(width: w * 0.25, height: w * 0.25)
                .clipShape(Circle())
        }
        .contentShape(Circle())
        .offset(x: w * 0.48, y: h * 0.63)
    }

  
    
    // MARK: - Level 2 View（原 ContentView3）
    @ViewBuilder
    func levelThreeView(w: CGFloat, h: CGFloat) -> some View {
        Image("Next Page")
            .resizable()
            .ignoresSafeArea()
            .scaledToFill()
            .frame(width: w, height: h)
        
    }

    // MARK: - 共用邏輯
    private func handleTap() {
        withAnimation {
            if correctPopup {
                advanceLevel()
            }
            correctPopup = false
            errorPopup = false
        }
    }

    private func advanceLevel() {
        switch currentLevel {
        case .level1:
            currentLevel = .level2
        case .level2:
            print("🎉 全部關卡完成！")
            // 可在此導向完結畫面
        }
    }

    func playSound(named soundName: String) {
        if let path = Bundle.main.path(forResource: soundName, ofType: "m4a") {
            let url = URL(fileURLWithPath: path)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                print("音效播放失敗")
            }
        }
    }
}

#Preview {
    RecognitionView()
}
