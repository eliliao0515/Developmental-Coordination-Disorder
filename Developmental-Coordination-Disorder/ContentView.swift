//
//  ContentView.swift
//  PageToPage
//
//  Created by 訪客使用者 on 2026/3/6.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Image("Background")
                    .resizable()
                    .scaledToFill()
                
                HStack {
                    VStack {
                        NavigationLink(destination: GameSelectionView()) {
                            GlassButtonContent(text: "手部訓練（未開發）", width: 490, height: 580)
                        }
                        .disabled(true)
                    }
                    Spacer()
                        .frame(width: 57)
                    VStack {
                        NavigationLink(destination: GameSelectionView()) {
                            GlassButtonContent(text: "寫字訓練（未開發）", width: 490, height: 273)
                        }
                        .disabled(true)
                        Spacer()
                            .frame(height: 34)
                        NavigationLink(destination: GameSelectionView()) {
                            GlassButtonContent(text: "視知覺", width: 490, height: 273)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
