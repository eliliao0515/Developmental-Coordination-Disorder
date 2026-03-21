import SwiftUI

// MARK: - Data

struct CardItem: Identifiable {
    let id: Int
    let title: String
}

// MARK: - Main View

struct SnapCarouselView: View {
    @Environment(\.dismiss) var dismiss
    
    let cards: [CardItem] = [
        CardItem(id: 0, title: "Easy"),
        CardItem(id: 0, title: "Medium"),
        CardItem(id: 0, title: "Challenging"),
        CardItem(id: 0, title: "Extreme"),
    ]

    // The index of the card currently in the center slot (slot index 1 out of 0-2)
    @State private var activeIndex: Int = 1
    @State private var dragOffset: CGFloat = 0

    // Layout
    // We show 3 slots on screen: left, center, right (plus a peek of a 4th)
    // Slot positions are evenly spaced
    let slotCount: Int = 3          // visible slots
    let cardWidth: CGFloat = 293
    let cardHeight: CGFloat = 618
    let slotSpacing: CGFloat = 49

    var slotStep: CGFloat { cardWidth + slotSpacing }

    var body: some View {
        GeometryReader { geo in
            let centerX = geo.size.width / 2

            ZStack {
                Image("BackgroundCoral")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                ForEach(Array(cards.enumerated()), id: \.offset) { index, card in
                    let position = slotPosition(
                        cardIndex: index,
                        activeIndex: activeIndex,
                        centerX: centerX,
                        dragOffset: dragOffset
                    )
                    let distanceFromCenter = abs(position - centerX)
                    let isFocused = index == activeIndex && dragOffset == 0

                    // Visual transforms based on distance from center
                    let scale: CGFloat = max(0.78, 1.0 - distanceFromCenter / (slotStep * 2.5))
                    let opacity: Double = max(0.4, 1.0 - Double(distanceFromCenter) / Double(slotStep * 1.8))

                    Button {
                        if isFocused {
                            print("Tapped: \(card.title)")
                        }
                    } label: {
                        Image("\(card.title)")
                            .resizable()
                        .frame(width: cardWidth, height: cardHeight)
                    }
                    .buttonStyle(.plain)
                    .disabled(!isFocused)
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .position(x: position, y: geo.size.height / 2)
                    .animation(.spring(response: 0.35, dampingFraction: 0.78), value: activeIndex)
                    .animation(.interactiveSpring(), value: dragOffset)
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation.width
                    }
                    .onEnded { value in
                        let threshold = slotStep * 0.3
                        let velocity = value.predictedEndTranslation.width - value.translation.width

                        var newIndex = activeIndex
                        if value.translation.width + velocity < -threshold {
                            newIndex = min(cards.count - 1, activeIndex + 1)
                        } else if value.translation.width + velocity > threshold {
                            newIndex = max(0, activeIndex - 1)
                        }

                        withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                            activeIndex = newIndex
                            dragOffset = 0
                        }

                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                    }
            )
        }
        .ignoresSafeArea()
        .overlay(alignment: .topLeading) {
            Button { dismiss() } label: {
                Image("BackButton")
            }
            .position(x: 81, y: 18)
        }
        .navigationBarBackButtonHidden(true)
    }

    // Compute the X position of a card given the active index + drag offset
    private func slotPosition(
        cardIndex: Int,
        activeIndex: Int,
        centerX: CGFloat,
        dragOffset: CGFloat
    ) -> CGFloat {
        let offset = CGFloat(cardIndex - activeIndex)
        return centerX + offset * slotStep + dragOffset
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        VStack() {
            SnapCarouselView()

            Text("Swipe to browse · Center button is active")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
    }
}



