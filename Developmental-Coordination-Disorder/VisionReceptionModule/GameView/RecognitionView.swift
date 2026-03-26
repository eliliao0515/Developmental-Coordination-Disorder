import SwiftUI
import AVFoundation

// 定義關卡的 enum
enum GameLevel {
    case level1
    case level2
    case level3
    case level4
}

struct RecognitionView: View {
    
    @State private var correctPopup: Bool = false
    @State private var errorPopup: Bool = false
    @State var audioPlayer: AVAudioPlayer?
    @State private var currentLevel: GameLevel = .level1
    
    @State private var gameOver: Bool = false

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
                        levelTwoView(w: w, h: h)

                    case .level3:
                        levelThreeView(w: w, h: h)
                        
                    case .level4:
                        levelFourView(w: w, h: h)
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
                            Image(correctPopup ? "Element-Correct" : "Element-Wrong")
                                .resizable()
                                .scaledToFit()
                                .frame(width: w * 0.8)
                                .cornerRadius(20)
                                .shadow(color: .black.opacity(0.3), radius: 20, x: 10, y: 10)
                                .transition(.scale)
                                .onTapGesture {
                                    if !gameOver {
                                        handleTap()
                                    }
                                }
                            Spacer()
                        }
                        .frame(width: w, height: h)
                    }
                    
                    if gameOver {
                        Color.clear
                            .frame(width: w, height: h)
                            .contentShape(Rectangle())
                            .allowsHitTesting(true)
                    }
                }
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .overlay(alignment: .topLeading) {
            BackButton(imageName: "Element-Backbutton", positionPadding: 0)
        }
    }

    // MARK: - Level 1 View (Group_339 - new first page)
    @ViewBuilder
    func levelOneView(w: CGFloat, h: CGFloat) -> some View {
        Image("BackgroundCoral")
            .resizable()
            .ignoresSafeArea()
            .scaledToFill()
            .frame(width: w, height: h)

        // Tap anywhere on the screen to advance to level 2
        // Or add a specific button if needed — adjust offset to match your image layout
        Button(action: {
            withAnimation {
                advanceLevel()
            }
        }) {
            Color.clear
                .frame(width: w, height: h)
        }
    }

    // MARK: - Level 2 View (Visual Recognition - was level 2, now second page)
    @ViewBuilder
    func levelTwoView(w: CGFloat, h: CGFloat) -> some View {
        Image("VisualReception-Recognition-G0")
            .resizable()
            .ignoresSafeArea()
            .scaledToFill()
            .frame(width: w, height: h)

        Image("Element-Volume")
            .resizable()
            .scaledToFit()
            .frame(width: w * 0.055, height: w * 0.055)
            .offset(x: w * 0.75, y: h * 0.265)

        // 錯誤泡泡
        FloatImage(
            imageName: "VisualReception-G1-Bubble1",
            positionPadding: 0,
            width: w * 0.185,
            height: w * 0.185,
            xPosition: (w * 0.1) + (w * 0.0925),
            yPosition: (h * 0.6) + (w * 0.0925),
            clipAsCircle: true
        ) {
            audioPlayer?.stop()
            errorPopup = true
        }

        FloatImage(
            imageName: "VisualReception-G1-Bubble2",
            positionPadding: 0,
            width: w * 0.25,
            height: w * 0.25,
            xPosition: (w * 0.3) + (w * 0.125),
            yPosition: (h * 0.43) + (w * 0.125),
            invertFloatingDirection: true,
            clipAsCircle: true
        ) {
            audioPlayer?.stop()
            errorPopup = true
        }

        FloatImage(
            imageName: "VisualReception-G1-Bubble4",
            positionPadding: 0,
            width: w * 0.25,
            height: w * 0.25,
            xPosition: (w * 0.65) + (w * 0.125),
            yPosition: (h * 0.43) + (w * 0.125),
            invertFloatingDirection: true,
            clipAsCircle: true
        ) {
            audioPlayer?.stop()
            errorPopup = true
        }

        // 正確答案
        FloatImage(
            imageName: "VisualReception-G1-Bubble3",
            positionPadding: 0,
            width: w * 0.25,
            height: w * 0.25,
            xPosition: (w * 0.48) + (w * 0.125),
            yPosition: (h * 0.63) + (w * 0.125),
            clipAsCircle: true
        ) {
            audioPlayer?.stop()
            correctPopup = true
        }
    }

    // MARK: - Level 3 View
    @ViewBuilder
    func levelThreeView(w: CGFloat, h: CGFloat) -> some View {
        Image("BackgroundCoral")
            .resizable()
            .ignoresSafeArea()
            .scaledToFill()
            .frame(width: w, height: h)

        // Tap anywhere on the screen to advance to level 2
        // Or add a specific button if needed — adjust offset to match your image layout
        Button(action: {
            withAnimation {
                advanceLevel()
            }
        }) {
            Color.clear
                .frame(width: w, height: h)
        }
    }
    
    // MARK: - Level 4 View
    @ViewBuilder
    func levelFourView(w: CGFloat, h: CGFloat) -> some View {
        Image("VisualReception-Recognition-G2")
            .resizable()
            .ignoresSafeArea()
            .scaledToFill()
            .frame(width: w, height: h)

        Image("Element-Volume")
            .resizable()
            .scaledToFit()
            .frame(width: w * 0.055, height: w * 0.055)
            .offset(x: w * 0.75, y: h * 0.265)

        // 錯誤泡泡
        FloatImage(
            imageName: "VisualReception-G2-Bubble1",
            positionPadding: 0,
            width: w * 0.185,
            height: w * 0.185,
            xPosition: (w * 0.1) + (w * 0.0925),
            yPosition: (h * 0.6) + (w * 0.0925),
            clipAsCircle: true
        ) {
            audioPlayer?.stop()
            errorPopup = true
        }

        FloatImage(
            imageName: "VisualReception-G2-Bubble2",
            positionPadding: 0,
            width: w * 0.25,
            height: w * 0.25,
            xPosition: (w * 0.3) + (w * 0.125),
            yPosition: (h * 0.43) + (w * 0.125),
            invertFloatingDirection: true,
            clipAsCircle: true
        ) {
            audioPlayer?.stop()
            errorPopup = true
        }

        FloatImage(
            imageName: "VisualReception-G2-Bubble3",
            positionPadding: 0,
            width: w * 0.25,
            height: w * 0.25,
            xPosition: (w * 0.48) + (w * 0.125),
            yPosition: (h * 0.63) + (w * 0.125),
            clipAsCircle: true
        ) {
            audioPlayer?.stop()
            errorPopup = true
        }
        // 正確答案
        FloatImage(
            imageName: "VisualReception-G2-Bubble4",
            positionPadding: 0,
            width: w * 0.25,
            height: w * 0.25,
            xPosition: (w * 0.65) + (w * 0.125),
            yPosition: (h * 0.43) + (w * 0.125),
            invertFloatingDirection: true,
            clipAsCircle: true
        ) {
            audioPlayer?.stop()
            correctPopup = true
            gameOver = true
        }
    }

    // MARK: - 共用邏輯
    private func handleTap() {
        withAnimation {
            if correctPopup {
                advanceLevel()
            }
            if errorPopup && currentLevel == .level2 {
                playSound(named: "Eli")
            }
            if errorPopup && currentLevel == .level4 {
                playSound(named: "lupinyu")
            }
            correctPopup = false
            errorPopup = false
        }
    }

    private func advanceLevel() {
        switch currentLevel {
        case .level1:
            currentLevel = .level2
            playSound(named: "Eli")
        case .level2:
            currentLevel = .level3
        case .level3:
            currentLevel = .level4
            playSound(named: "lupinyu")
        case .level4:
            print("🎉 全部關卡完成！")
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
