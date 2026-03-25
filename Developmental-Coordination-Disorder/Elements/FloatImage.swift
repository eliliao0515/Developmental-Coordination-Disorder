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
    var width: CGFloat = 106
    var height: CGFloat = 108
    var xPosition: CGFloat = 78
    var yPosition: CGFloat = 63
    var floatingOffset: CGFloat = 12
    var invertFloatingDirection: Bool = false
    var clipAsCircle: Bool = false
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button {
            if let action {
                action()
            } else {
                dismiss()
            }
        } label: {
            if clipAsCircle {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: height)
                    .clipShape(Circle())
                    .offset(y: isFloating ? (invertFloatingDirection ? floatingOffset : -floatingOffset) : 0)
                    .animation(
                        .easeInOut(duration: 1.5)
                        .repeatForever(autoreverses: true),
                        value: isFloating
                    )
                    .onAppear { isFloating = true }
            } else {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: height)
                    .offset(y: isFloating ? (invertFloatingDirection ? floatingOffset : -floatingOffset) : 0)
                    .animation(
                        .easeInOut(duration: 1.5)
                        .repeatForever(autoreverses: true),
                        value: isFloating
                    )
                    .onAppear { isFloating = true }
            }
        }
        .position(x: xPosition, y: yPosition)
        .padding(.top, CGFloat(positionPadding))
    }
}

struct BackButton: View {
    @Environment(\.dismiss) var dismiss
    
    let imageName: String
    let positionPadding: Int
    
    var body: some View {
        Button { dismiss() } label: {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 106, height: 108)
        }
        .position(x: 78, y: 63)
        .padding(.top, CGFloat(positionPadding))
    }
}
