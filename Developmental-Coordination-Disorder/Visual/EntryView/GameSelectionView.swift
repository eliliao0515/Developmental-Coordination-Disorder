//
//  SecondPage.swift
//  PageToPage
//
//  Created by 訪客使用者 on 2026/3/6.
//

import SwiftUI

struct GameSelectionView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Image("BackgroundCoral")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            HStack {
                NavigationLink(destination: DifficultyView(highestLevel: 2, game: GameName.recognition)) {
                    GlassButtonContent(text: "Recognition", width: 293, height: 617)
                }
                
                Spacer()
                    .frame(width: 58)
                
                NavigationLink(destination: DifficultyView(highestLevel: 3, game: GameName.memory)) {
                    GlassButtonContent(text: "Memory", width: 293, height: 617)
                }
                
                Spacer()
                    .frame(width: 58)
                
                NavigationLink(destination: DifficultyView(highestLevel: 3, game: GameName.space)) {
                    GlassButtonContent(text: "Space", width: 293, height: 617)
                }
            }
        }
        .overlay(alignment: .topLeading) {
            Button { dismiss() } label: {
                Image("BackButton")
            }
            .offset(x: 81, y: 18)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    GameSelectionView()
}
