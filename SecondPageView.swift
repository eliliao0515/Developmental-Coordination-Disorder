//
//  SecondPage.swift
//  PageToPage
//
//  Created by 訪客使用者 on 2026/3/6.
//

import SwiftUI

struct SecondPageView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Image("BackgroundCoral")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            HStack {
                NavigationLink(destination: SnapCarouselView()) {
                    GlassButtonContent(text: "Me is Button", width: 293, height: 617)
                }
                
                Spacer()
                    .frame(width: 58)
                
                NavigationLink(destination: SecondPageView()) {
                    GlassButtonContent(text: "Me is Button", width: 293, height: 617)
                }
                .disabled(true)
                
                Spacer()
                    .frame(width: 58)
                
                NavigationLink(destination: SecondPageView()) {
                    GlassButtonContent(text: "Me is Button", width: 293, height: 617)
                }
                .disabled(true)
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
    SecondPageView()
}
