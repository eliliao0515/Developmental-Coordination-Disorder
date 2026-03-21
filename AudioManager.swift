//
//  AudioManager.swift
//  DCDApp
//
//  Created by 訪客使用者 on 2026/3/20.
//


import SwiftUI
import Combine
import AVFoundation

// MARK: - AudioManager (保持不變)
class AudioManager {
    static let shared = AudioManager()
    var player: AVAudioPlayer?

    func playSound(named fileName: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "m4a") else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("無法播放聲音: \(error)")
        }
    }
    
    func stopSound() {
        player?.stop()
        player = nil
    }
}

struct KaiView: View {
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common)
    @State private var timerSubscription: Cancellable? = nil

    @State private var gameState = 0
    @State private var countdown = 5
    @State private var currentLevel = 1

    var body: some View {
        ZStack {
            switch gameState {
            case 0:
                countdownView
            case 1:
                selectionView
            case 2:
                resultView(imageName: "correct", isCorrect: true)
            case 3:
                resultView(imageName: "wrong", isCorrect: false)
            default:
                EmptyView()
            }
        }
        .ignoresSafeArea()
    }

    // MARK: - 1. 倒數計時介面
    var countdownView: some View {
        GeometryReader { geometry in
            ZStack {
                Image("Background_Countdown")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)

                Text("\(countdown)")
                    .font(.system(size: 80, weight: .bold))
                    .foregroundColor(.black)
                    .offset(y: 88)
                    .onReceive(timer) { _ in
                        if countdown > 1 {
                            countdown -= 1
                        } else {
                            stopTimer()
                            withAnimation { gameState = 1 }
                        }
                    }

                // 修改：將 Button 改為 Image，移除所有點擊特效與功能
                Image("voice_button")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .position(x: geometry.size.width * 0.765, y: geometry.size.height * 0.808)
            }
        }
        .onAppear {
            startTimer()
            playLevelSound() // 進入畫面時自動觸發播放
        }
        .onDisappear {
            AudioManager.shared.stopSound() // 離開畫面時立即停止
        }
    }

    func playLevelSound() {
        // 這裡可以根據 currentLevel 換檔名，目前設為一致
        let soundName = currentLevel == 1 ? "lupinyu" : "lupinyu"
        AudioManager.shared.playSound(named: soundName)
    }

    // MARK: - 2. 選擇介面 (保持不變)
    var selectionView: some View {
        GeometryReader { geometry in
            ZStack {
                Image("Background_Selection")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)

                if currentLevel == 1 {
                    Group {
                        paperButton(imageName: "Paper_TL", isCorrect: true)
                            .position(x: geometry.size.width * 0.36, y: geometry.size.height * 0.28)
                        paperButton(imageName: "Paper_TR", isCorrect: false)
                            .position(x: geometry.size.width * 0.74, y: geometry.size.height * 0.32)
                        paperButton(imageName: "Paper_BL", isCorrect: false)
                            .position(x: geometry.size.width * 0.22, y: geometry.size.height * 0.54)
                        paperButton(imageName: "Paper_BR", isCorrect: false)
                            .position(x: geometry.size.width * 0.58, y: geometry.size.height * 0.54)
                    }
                } else if currentLevel == 2 {
                    Group {
                        paperButton(imageName: "New_TL", isCorrect: false)
                            .position(x: geometry.size.width * 0.36, y: geometry.size.height * 0.28)
                        paperButton(imageName: "New_TR", isCorrect: false)
                            .position(x: geometry.size.width * 0.74, y: geometry.size.height * 0.32)
                        paperButton(imageName: "New_RT", isCorrect: false)
                            .position(x: geometry.size.width * 0.22, y: geometry.size.height * 0.54)
                        paperButton(imageName: "New_RL", isCorrect: true)
                            .position(x: geometry.size.width * 0.58, y: geometry.size.height * 0.54)
                    }
                }
            }
        }
    }

    // MARK: - 3 & 4. 結果顯示介面 (保持不變)
    func resultView(imageName: String, isCorrect: Bool) -> some View {
        ZStack {
            Image(imageName)
                .resizable()
                .scaledToFill()
            
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    if isCorrect {
                        if currentLevel == 1 {
                            currentLevel = 2
                            countdown = 5
                            withAnimation { gameState = 0 }
                        }
                    } else {
                        withAnimation { gameState = 1 }
                    }
                }
        }
        .onAppear { stopTimer() }
    }

    // MARK: - 輔助元件
    func paperButton(imageName: String, isCorrect: Bool) -> some View {
        Button(action: {
            withAnimation(.spring()) {
                gameState = isCorrect ? 2 : 3
            }
        }) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 240)
        }
        .buttonStyle(PlainButtonStyle())
    }

    func startTimer() {
        stopTimer()
        timer = Timer.publish(every: 1, on: .main, in: .common)
        timerSubscription = timer.connect()
    }

    func stopTimer() {
        timerSubscription?.cancel()
        timerSubscription = nil
    }
}

#Preview {
    KaiView()
}

