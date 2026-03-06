//
//  GlassButton.swift
//  PageToPage
//
//  Created by 訪客使用者 on 2026/3/6.
//

import SwiftUI

struct GlassButtonContent: View {
    let text: String
    let width: Int
    let height: Int
    
    var body: some View {
        ZStack {
            // 1. The Glass Base
            RoundedRectangle(cornerRadius: 25)
                .fill(.ultraThinMaterial)
                .frame(width: CGFloat(width), height: CGFloat(height))
                // .padding(.horizontal, 40)
            
            // 3. The Label Text
            Text(text)
                .font(.title2.bold())
                .foregroundColor(.white)
        }
        // 4. The Shadow at the lower right
        .shadow(color: .black.opacity(0.7), radius: 15, x: 10, y: 10)
    }
}
