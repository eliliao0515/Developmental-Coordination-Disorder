import SwiftUI
import AVKit

// MARK: - 資料結構
struct VideoItem: Identifiable {
    let id = UUID()
    let imageName: String
}

struct HandView: View {
    // 規格：W192, 間距 64
    let columns = [
        GridItem(.fixed(192), spacing: 64),
        GridItem(.fixed(192), spacing: 64),
        GridItem(.fixed(192), spacing: 64)
    ]
    
    @State private var scrollPosition: Int? = 0
    
    // --- 這裡完全依照你的要求，不進行任何動動 ---
    let videoItems: [VideoItem] = [
        // 第一頁 (1-9)
        VideoItem(imageName: "HandVideo11"), VideoItem(imageName: "HandVideo12"), VideoItem(imageName: "HandVideo13"),
        VideoItem(imageName: "HandVideo21"), VideoItem(imageName: "HandVideo22"), VideoItem(imageName: "HandVideo23"),
        VideoItem(imageName: "HandVideo31"), VideoItem(imageName: "HandVideo32"), VideoItem(imageName: "HandVideo33"),
        // 第二頁 (10-18)
        VideoItem(imageName: "HandVideo41"), VideoItem(imageName: "HandVideo42"), VideoItem(imageName: "HandVideo43"),
        VideoItem(imageName: "HandVideo51"), VideoItem(imageName: "HandVideo52"), VideoItem(imageName: "HandVideo53"),
        VideoItem(imageName: "HandVideo61"), VideoItem(imageName: "HandVideo62"), VideoItem(imageName: "HandVideo63"),
        // 第三頁 (19-27)
        VideoItem(imageName: "HandVideo71"), VideoItem(imageName: "HandVideo72"), VideoItem(imageName: "HandVideo73"),
        VideoItem(imageName: "HandVideo82")
    ]
    
    // 分頁邏輯：每頁 9 張
    var pagedItems: [[VideoItem]] {
        stride(from: 0, to: videoItems.count, by: 9).map {
            Array(videoItems[$0..<min($0 + 9, videoItems.count)])
        }
    }

    var columnCount: Int { columns.count }

    func pageItemsForDisplay(_ items: [VideoItem]) -> [VideoItem?] {
        var displayItems = items.map(Optional.some)
        if items.count % columnCount == 1 {
            displayItems.insert(nil, at: items.count - 1)
        }
        return displayItems
    }
    
    let pageHeight: CGFloat = 520

    var body: some View {
        NavigationStack {
            ZStack {
                // 1. 背景層
                Image("bg_main")
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
                
                // 2. 主內容與右側分頁標示器
                HStack(alignment: .center) {
                    Spacer().frame(width: 30)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 0) {
                            ForEach(0..<pagedItems.count, id: \.self) { pageIndex in
                                VStack {
                                    LazyVGrid(columns: columns, spacing: 30) {
                                        ForEach(Array(pageItemsForDisplay(pagedItems[pageIndex]).enumerated()), id: \.offset) { _, item in
                                            if let item {
                                                LiquidVideoButton(item: item)
                                            } else {
                                                Color.clear
                                                    .frame(width: 192, height: 147)
                                            }
                                        }
                                    }
                                    .padding(.vertical, 20)
                                }
                                .frame(width: 810, height: pageHeight)
                                .id(pageIndex)
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollPosition(id: $scrollPosition)
                    .scrollTargetBehavior(.paging)
                    .frame(width: 810, height: pageHeight)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .offset(y: 20)
                    
                    // 右側分頁點
                    VStack(spacing: 12) {
                        ForEach(0..<pagedItems.count, id: \.self) { index in
                            Circle()
                                .fill(scrollPosition == index ? Color.gray : Color.gray.opacity(0.3))
                                .frame(width: 10, height: 10)
                                .scaleEffect(scrollPosition == index ? 1.2 : 1.0)
                                .animation(.spring(), value: scrollPosition)
                        }
                    }
                    .frame(width: 20)
                    .offset(y: 20)
                }
                
                // 3. 右下角裝飾 (鸚鵡)
                GeometryReader { geo in
                    Image("redbird")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width * 0.18)
                        .position(x: geo.size.width * 0.85, y: geo.size.height * 0.85)
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

// MARK: - 玻璃按鈕元件
struct LiquidVideoButton: View {
    let item: VideoItem
    var body: some View {
        NavigationLink(destination: VideoDetailView(item: item)) {
            ZStack {
                Color.white
                    .opacity(0.15)
                    .blendMode(.saturation)
                    .cornerRadius(16)
                
                Image(item.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 165)
            }
        }
        .buttonStyle(.plain)
        .frame(width: 192, height: 147)
        .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 3)
        .glassEffect(.clear, in: .rect(cornerRadius: 16))
    }
}

// MARK: - 詳情頁面 (動畫修改重點)
struct VideoDetailView: View {
    let item: VideoItem
    @Environment(\.dismiss) var dismiss
    
    @State private var player = AVPlayer()
    @State private var selectedDifficulty: String = "易"
    @State private var isFullScreen = false
    
    // 建立命名空間來追蹤視圖幾何位置
    @Namespace private var videoNamespace
    
    let difficultyButtons: [(label: String, imageName: String)] = [
        ("易", "btn_easy"),
        ("中", "btn_medium"),
        ("難", "btn_hard")
    ]
    
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            
            ZStack {
                Image("bg_video").resizable().ignoresSafeArea()
                
                HStack(spacing: 0) {
                    Spacer().frame(width: w * 0.18)
                    
                    VStack {
                        ZStack(alignment: .bottomTrailing) {
                            // 加上 matchedGeometryEffect 達成縮放
                            VideoPlayer(player: player)
                                .matchedGeometryEffect(id: "PLAYER_ID", in: videoNamespace)
                                .clipShape(RoundedRectangle(cornerRadius: w * 0.016))
                                .shadow(color: .black.opacity(0.2), radius: w * 0.008, x: 0, y: h * 0.005)
                            
                            Button {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                                    isFullScreen = true
                                }
                            } label: {
                                Image(systemName: "arrow.up.left.and.arrow.down.right")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color.black.opacity(0.5))
                                    .clipShape(Circle())
                                    .padding(15)
                            }
                        }
                        .frame(width: w * 0.585, height: h * 0.60)
                    }
                    
                    VStack(spacing: h * 0.03) {
                        ForEach(difficultyButtons, id: \.label) { btn in
                            Button {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                    selectedDifficulty = btn.label
                                    changeVideo(to: btn.label)
                                }
                            } label: {
                                Image(btn.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: w * 0.1)
                                    .scaleEffect(selectedDifficulty == btn.label ? 1.1 : 1.0)
                                    .padding(.vertical, h * 0.02)
                            }
                        }
                    }
                    .frame(width: w * 0.25)
                }
                
                // 取代 fullScreenCover，改用條件式顯示來支援幾何動畫
                if isFullScreen {
                    FullScreenVideoView(player: player, isPresented: $isFullScreen, namespace: videoNamespace)
                        .transition(.asymmetric(insertion: .identity, removal: .identity))
                }
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .onAppear { changeVideo(to: selectedDifficulty) }
        .onDisappear { player.pause() }
        .overlay(alignment: .topLeading) {
            if !isFullScreen {
                BackButton(imageName: "BackButton", positionPadding: 0)
            }
        }
    }
    
    func changeVideo(to difficulty: String) {
        let videoName: String
        switch difficulty {
        case "易": videoName = "video_easy"
        case "中": videoName = "video_medium"
        case "難": videoName = "video_hard"
        default:  videoName = "IMG_8515"
        }
        guard let url = Bundle.main.url(forResource: videoName, withExtension: "mov") else { return }
        let newItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: newItem)
        player.play()
    }
}

// MARK: - 全螢幕播放組件
struct FullScreenVideoView: View {
    let player: AVPlayer
    @Binding var isPresented: Bool
    var namespace: Namespace.ID
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.black.ignoresSafeArea()
            
            // 這裡也綁定同一個 ID
            VideoPlayer(player: player)
                .matchedGeometryEffect(id: "PLAYER_ID", in: namespace)
                .ignoresSafeArea()
            
            Button {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                    isPresented = false
                }
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.white.opacity(0.8))
                    .padding()
            }
        }
        .onAppear { player.play() }
    }
}
#Preview {
    HandView()
}
