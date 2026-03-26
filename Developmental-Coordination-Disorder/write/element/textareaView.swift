//
//  textareaView.swift
//  write
//
//  Created by 李天 on 2026/3/6.
//

import SwiftUI

struct textareaView: View {
    @Binding var isExpendedGoal :Bool
    @Binding var isExpendedPlan :Bool
    @Binding var isExpendedDo :Bool
    @Binding var isExpendedExplain :Bool
    let title: String = "目標"
    var body: some View {
        VStack{
            Spacer()
            VStack{
                DisclosureGroup(isExpanded: $isExpendedGoal){
                    Text("把圖形畫得又穩又漂亮，控制好拿筆的力氣，讓線條看起來整齊又清楚喔～")
                        .frame(width: 350 , height: 200)
                        .font(.custom("BpmfZihiKaiStd-Regular", size: 30))
                        .foregroundStyle(Color.fontBrown)
                } label: {
                    toggleTitleView(text: title , isExpended: $isExpendedGoal)
                        .tint(.black)
                }
            }
            .onChange(of: isExpendedGoal) { oldValue, newValue in
                            if newValue == true { // 如果 Goal 被打開了，就關閉其他三個
                                isExpendedPlan = false
                                isExpendedDo = false
                                isExpendedExplain = false
                            }
                        }
            Spacer()
            VStack{
                DisclosureGroup(isExpanded: $isExpendedPlan){
                    Text("把圖形畫得又穩又漂亮，控制好拿筆的力氣，讓線條看起來整齊又清楚喔～")
                        .frame(width: 350 , height: 200)
                        .font(.custom("BpmfZihiKaiStd-Regular", size: 30))
                        .foregroundStyle(Color.fontBrown)
                } label: {
                    toggleTitleView(text: "計畫" , isExpended: $isExpendedPlan)
                        .tint(.black)
                }
            }
            .onChange(of: isExpendedPlan) { oldValue, newValue in
                            if newValue == true {
                                isExpendedGoal = false
                                isExpendedDo = false
                                isExpendedExplain = false
                            }
                        }
            Spacer()
            VStack{
                DisclosureGroup(isExpanded: $isExpendedDo){
                    Text("把圖形畫得又穩又漂亮，控制好拿筆的力氣，讓線條看起來整齊又清楚喔～")
                        .frame(width: 350 , height: 200)
                        .font(.custom("BpmfZihiKaiStd-Regular", size: 30))
                        .foregroundStyle(Color.fontBrown)
                } label: {
                    toggleTitleView(text: "執行" , isExpended: $isExpendedDo)
                        .tint(.black)
                }
            }
            .onChange(of: isExpendedDo) { oldValue, newValue in
                            if newValue == true {
                                isExpendedGoal = false
                                isExpendedPlan = false
                                isExpendedExplain = false
                            }
                        }
            Spacer()
            VStack{
                DisclosureGroup(isExpanded: $isExpendedExplain){
                    Text("把圖形畫得又穩又漂亮，控制好拿筆的力氣，讓線條看起來整齊又清楚喔～")
                        .frame(width: 350 , height: 200)
                        .font(.custom("BpmfZihiKaiStd-Regular", size: 30))
                        .foregroundStyle(Color.fontBrown)
                } label: {
                    toggleTitleView(text: "解釋" , isExpended: $isExpendedExplain)
                        .tint(.black)
                }
            }
            .onChange(of: isExpendedExplain) { oldValue, newValue in
                            if newValue == true {
                                isExpendedGoal = false
                                isExpendedPlan = false
                                isExpendedDo = false
                            }
                        }
            Spacer()
        }
        .frame(maxWidth: 350 , maxHeight: 500)
        .animation(.easeInOut, value: isExpendedGoal)
                .animation(.easeInOut, value: isExpendedPlan)
                .animation(.easeInOut, value: isExpendedDo)
                .animation(.easeInOut, value: isExpendedExplain)
    }
}

#Preview {
    textareaView(
        isExpendedGoal: .constant(true),
        isExpendedPlan: .constant(false),
        isExpendedDo: .constant(false),
        isExpendedExplain: .constant(false)
    )
}
