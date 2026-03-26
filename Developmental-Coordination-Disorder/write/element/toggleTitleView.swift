//
//  toggleTitleView.swift
//  write
//
//  Created by 李天 on 2026/3/6.
//

import SwiftUI

struct toggleTitleView: View {
    let text: String
    @Binding var isExpended: Bool
    var body: some View {
        HStack{
            if isExpended{
                Rectangle()
                    .frame(width: 5 , height: 60)
            }
            Text(text)
                .font(.custom("BpmfZihiKaiStd-Regular", size: 45))
            Spacer()
            if isExpended{
                Button{
                    
                } label:{
                    Image("sound")
                        .resizable()
                        .frame(width: 50 , height: 50)
                }
                .padding()
            }
        }
    }
}

#Preview {
    toggleTitleView(text: "目標" , isExpended: .constant(true))
}
