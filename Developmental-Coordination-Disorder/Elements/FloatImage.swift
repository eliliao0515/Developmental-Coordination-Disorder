//
//  FloatImage.swift
//  Developmental-Coordination-Disorder
//
//  Created by Eli Liao on 2026/3/22.
//

import SwiftUI

struct FloatImage: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var isFloating: Bool = false
    let imageName: String
    let positionPadding: Int
    
    var body: some View {
        Button { dismiss() } label: {
            Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: 106, height: 108)
            .offset(y: isFloating ? -12 : 0)
            .animation(
                .easeInOut(duration: 1.5)
                .repeatForever(autoreverses: true),
                value: isFloating
            )
            .onAppear { isFloating = true }
        }
        .position(x: 78, y: 63)
        .padding(.top, CGFloat(positionPadding))
    }
}
