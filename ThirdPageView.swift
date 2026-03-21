//
//  ThirdPageView.swift
//  PageToPage
//
//  Created by 訪客使用者 on 2026/3/6.
//

import SwiftUI

struct ThirdPageView: View {
    var body: some View {
        ZStack {
            Image("BackgroundCoral")
                .resizable()
                .scaledToFill()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ThirdPageView()
}
