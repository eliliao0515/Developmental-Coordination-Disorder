//
//  goodView.swift
//  write
//
//  Created by 李天 on 2026/3/25.
//

import SwiftUI

struct goodView: View {
    var body: some View {
        ZStack{
            Image("paper")
                .resizable()
            VStack(alignment: .center , spacing: 50){
                Image(systemName: "hands.and.sparkles.fill")
                    .font(.system(size: 200))
                    .foregroundStyle(Color.cyan)
                Text("你真棒！")
                    .font(.custom("BpmfZihiKaiStd-Regular", size: 60))
                    .foregroundStyle(Color.fontBrown)
            }
        }
        .frame(width: 1000 , height: 680)
    }
}

#Preview {
    goodView()
}
