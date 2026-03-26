//
//  perfectView.swift
//  write
//
//  Created by 李天 on 2026/3/25.
//

import SwiftUI

struct perfectView: View {
    var body: some View {
        ZStack{
            Image("paper")
                .resizable()
            VStack(alignment: .center , spacing: 50){
                Image(systemName: "star.fill")
                    .font(.system(size: 200))
                    .foregroundStyle(Color.yellow)
                Text("太厲害啦！")
                    .font(.custom("BpmfZihiKaiStd-Regular", size: 60))
                    .foregroundStyle(Color.fontBrown)
            }
        }
        .frame(width: 1000 , height: 680)
    }
}

#Preview {
    perfectView()
}
