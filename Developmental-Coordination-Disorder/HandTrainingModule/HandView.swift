import SwiftUI
import AVKit

// MARK: - 資料結構
struct VideoItem: Identifiable {
    let id = UUID()
    let imageName: String
}

struct HandView: View {
    let columns = [
        GridItem(.fixed(192), spacing: 64),
        GridItem(.fixed(192), spacing: 64),
        GridItem(.fixed(192), spacing: 64)
    ]

    @State private var scrollPosition: Int? = 0

    let videoItems: [VideoItem] = [
        VideoItem(imageName: "HandVideo11"), VideoItem(imageName: "HandVideo12"), VideoItem(imageName: "HandVideo13"),
        VideoItem(imageName: "HandVideo21"), VideoItem(imageName: "HandVideo22"), VideoItem(imageName: "HandVideo23"),
        VideoItem(imageName: "HandVideo31"), VideoItem(imageName: "HandVideo32"), VideoItem(imageName: "HandVideo33"),
        VideoItem(imageName: "HandVideo41"), VideoItem(imageName: "HandVideo42"), VideoItem(imageName: "HandVideo43"),
        VideoItem(imageName: "HandVideo51"), VideoItem(imageName: "HandVideo52"), VideoItem(imageName: "HandVideo53"),
        VideoItem(imageName: "HandVideo61"), VideoItem(imageName: "HandVideo62"), VideoItem(imageName: "HandVideo63"),
        VideoItem(imageName: "HandVideo71"), VideoItem(imageName: "HandVideo72"), VideoItem(imageName: "HandVideo73"),
        VideoItem(imageName: "HandVideo82")
    ]

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
                Image("HandSelection")
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()

                HStack(alignment: .center, spacing: 20) {
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
                    .offset(y: 60)

                    VStack(spacing: 12) {
                        ForEach(0..<pagedItems.count, id: \.self) { index in
                            Circle()
                                .fill((scrollPosition ?? 0) == index ? Color.white : Color.white.opacity(0.3))
                                .frame(width: 10, height: 10)
                                .scaleEffect((scrollPosition ?? 0) == index ? 1.3 : 1.0)
                                .animation(.spring(duration: 0.3), value: scrollPosition)
                        }
                    }
                    .frame(width: 30)
                    .offset(y: 60)
                }

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
            BackButton(imageName: "Element-Backbutton", positionPadding: 0)
        }
    }
}

// MARK: - 玻璃按鈕元件
struct LiquidVideoButton: View {
    let item: VideoItem

    var body: some View {
        NavigationLink(destination: VideoDetailView(item: item)) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.15))
                    .frame(width: 192, height: 147)

                Image(item.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 165)
            }
        }
        .buttonStyle(.plain)
        .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 3)
    }
}

// MARK: - 詳情頁面
struct VideoDetailView: View {
    let item: VideoItem
    @Environment(\.dismiss) var dismiss

    @State private var player = AVPlayer()
    @State private var selectedDifficulty: String = "易"
    @State private var isFullScreen = false

    @Namespace private var videoNamespace

    let difficultyButtons: [(label: String, imageName: String)] = [
        ("易", "Hand-Btn-Easy"),
        ("中", "Hand-Btn-Medium"),
        ("難", "Hand-Btn-Hard")
    ]

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack {
                Image("HandGame").resizable().ignoresSafeArea()

                HStack(spacing: 0) {
                    Spacer().frame(width: w * 0.18)

                    VStack {
                        ZStack(alignment: .bottomTrailing) {
                            VideoPlayer(player: player)
                                .clipShape(RoundedRectangle(cornerRadius: w * 0.016))
                                .shadow(color: .black.opacity(0.2), radius: 10)
                                .matchedGeometryEffect(id: "video", in: videoNamespace)

                            Button {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                    isFullScreen = true
                                }
                            } label: {
                                Image(systemName: "arrow.up.left.and.arrow.down.right")
                                    .padding(12)
                                    .background(.ultraThinMaterial)
                                    .clipShape(Circle())
                                    .padding(15)
                            }
                        }
                        .frame(width: w * 0.585, height: h * 0.60)
                    }

                    VStack(spacing: h * 0.03) {
                        ForEach(difficultyButtons, id: \.label) { btn in
                            Button {
                                withAnimation(.interactiveSpring()) {
                                    selectedDifficulty = btn.label
                                    changeVideo(to: btn.label)
                                }
                            } label: {
                                Image(btn.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: w * 0.1)
                                    .scaleEffect(selectedDifficulty == btn.label ? 1.15 : 1.0)
                                    .brightness(selectedDifficulty == btn.label ? 0.1 : 0)
                            }
                        }
                    }
                    .frame(width: w * 0.25)
                }

                if isFullScreen {
                    FullScreenVideoView(player: player, isPresented: $isFullScreen, namespace: videoNamespace)
                }
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .onAppear { changeVideo(to: selectedDifficulty) }
        .onDisappear { player.pause() }
        .overlay(alignment: .topLeading) {
            if !isFullScreen {
                BackButton(imageName: "Element-Backbutton", positionPadding: 0)
            }
        }
    }

    func changeVideo(to difficulty: String) {
        let videoName: String
        switch difficulty {
        case "易": videoName = "videoEasy"
        case "中": videoName = "videoMedium"
        case "難": videoName = "videoHard"
        default: videoName = "videoEasy"
        }
        guard let url = Bundle.main.url(forResource: videoName, withExtension: "mov") else { return }
        player.replaceCurrentItem(with: AVPlayerItem(url: url))
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

            VideoPlayer(player: player)
                .matchedGeometryEffect(id: "video", in: namespace)
                .ignoresSafeArea()

            Button {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                    isPresented = false
                }
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 44))
                    .foregroundColor(.white.opacity(0.7))
                    .padding(40)
            }
        }
    }
}

#Preview {
    HandView()
}
