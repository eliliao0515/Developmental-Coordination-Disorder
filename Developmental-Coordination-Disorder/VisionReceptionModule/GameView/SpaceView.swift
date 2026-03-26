import SwiftUI

// 1. 資料結構
struct GlowingFishItem: Identifiable {
    let id = UUID()
    let name: String
    let relativePosition: CGPoint
}

struct SpaceView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var currentLevel = 1
    @State private var isGameStarted = false
    @State private var showCorrect = false
    @State private var showWrong = false
    @State private var showGameOver = false
    @State private var areFishFloating = false
    
    // 第一關資料
    let level1Background = "background1"
    let level1Fishes: [GlowingFishItem] = [
        GlowingFishItem(name: "green",  relativePosition: CGPoint(x: 200,  y: 600)),
        GlowingFishItem(name: "blue",   relativePosition: CGPoint(x: 480,  y: 420)),
        GlowingFishItem(name: "purple", relativePosition: CGPoint(x: 750,  y: 420)),
        GlowingFishItem(name: "red",    relativePosition: CGPoint(x: 1000, y: 600)),
    ]
    
    // 第二關資料
    let level2Background = "background2"
    let level2Fishes: [GlowingFishItem] = [
        GlowingFishItem(name: "fish2_1", relativePosition: CGPoint(x: 200,  y: 600)),
        GlowingFishItem(name: "fish2_2", relativePosition: CGPoint(x: 480,  y: 420)),
        GlowingFishItem(name: "fish2_3", relativePosition: CGPoint(x: 750,  y: 420)),
        GlowingFishItem(name: "fish2_4", relativePosition: CGPoint(x: 1000, y: 600)),
    ]
    
    var currentLevelBackground: String {
        currentLevel == 1 ? level1Background : level2Background
    }
    
    var currentFishes: [GlowingFishItem] {
        currentLevel == 1 ? level1Fishes : level2Fishes
    }
    
    func checkAnswer(fishName: String) {
        let correctAnswer = (currentLevel == 1) ? "green" : "fish2_2"
        if fishName == correctAnswer {
            showCorrect = true
        } else {
            showWrong = true
        }
    }

    var body: some View {
        ZStack {
            if !isGameStarted {
                // --- A. 關卡介紹面 ---
                ZStack {
                    Color.black.ignoresSafeArea()
                    Image("Level\(currentLevel)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 800)
                    
                    Text("關卡 \(currentLevel) - 點擊開始")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .offset(y: 300)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation { isGameStarted = true }
                }
                
            } else {
                // --- B. 遊戲畫面 ---
                ZStack {
                    Image(currentLevelBackground)
                        .resizable()
                        .ignoresSafeArea()
                    
                    VStack {
                        Image("paper").resizable().frame(width: 950, height: 230).offset(y: 20)
                        Spacer()
                    }.padding(.top, 40)
                    
                    ForEach(Array(currentFishes.enumerated()), id: \.element.id) { index, fish in
                        Button {
                            // 如果已經答對了且在第二關，就不再觸發按鈕，防止重複顯示
                            if !(currentLevel == 2 && showCorrect) {
                                checkAnswer(fishName: fish.name)
                            }
                        } label: {
                            Image(fish.name)
                                .resizable()
                                .scaledToFit()
                                .offset(y: areFishFloating ? (index.isMultiple(of: 2) ? -12 : 12) : 0)
                                .animation(
                                    .easeInOut(duration: 1.5)
                                    .repeatForever(autoreverses: true),
                                    value: areFishFloating
                                )
                                .onAppear { areFishFloating = true }
                        }
                        .frame(width: 350, height: 350)
                        .position(fish.relativePosition)
                    }
                    
                    // 答對彈窗
                    if showCorrect {
                        ZStack {
                            Color.black.opacity(0.6).ignoresSafeArea()
                            Image("Group 189").resizable().scaledToFit().frame(width: 800)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if currentLevel == 1 {
                                // 第一關點擊後進入下一關
                                showCorrect = false
                                currentLevel = 2
                                isGameStarted = false
                            } else {
                                // 第二關點擊後，什麼都不做，讓畫面停留在這裡
                                print("遊戲結束，停留在答對介面")
                                dismiss()
                            }
                        }
                    }
                    
                    // 答錯彈窗
                    if showWrong {
                        ZStack {
                            Color.black.opacity(0.6).ignoresSafeArea()
                            Image("Group 217").resizable().scaledToFit().frame(width: 800)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture { showWrong = false }
                    }
                }
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .overlay(alignment: .topLeading) {
            BackButton(imageName: "BackButton", positionPadding: 0)
        }
    }
}
#Preview {
    SpaceView()
}
