//
//  ContentView.swift
//  PageToPage
//
//  Created by 訪客使用者 on 2026/3/6.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Image("Background")
                    .resizable()
                    .scaledToFill()
                
                HStack {
                    VStack {
                        NavigationLink(destination: SecondPageView()) {
                            GlassButtonContent(text: "Me is Button", width: 490, height: 580)
                        }
                        .disabled(true)
                    }
                    Spacer()
                        .frame(width: 57)
                    VStack {
                        NavigationLink(destination: SecondPageView()) {
                            GlassButtonContent(text: "Me is Button", width: 490, height: 273)
                        }
                        .disabled(true)
                        Spacer()
                            .frame(height: 34)
                        NavigationLink(destination: SecondPageView()) {
                            GlassButtonContent(text: "Me is Button", width: 490, height: 273)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
