//
//  ColorAlgorithm.swift
//  write
//
//  Created by 李天 on 2026/3/14.
//

import Foundation
import SwiftUI

struct ColorAlgorithm{
    // 支援「完美區間」與「平滑漸層」的顏色演算法
    static func color(for force: CGFloat) -> Color {
        // 1. 定義力道區間與極限值
        let lightThreshold: CGFloat = 0.9
        let heavyThreshold: CGFloat = 2.1
        let maxForce: CGFloat = 3.0
        
        // 2. 定義對應的色相 (Hue) 數值
        let blueHue: Double = 0.60
        let greenHue: Double = 0.33
        let redHue: Double = 0.00
        
        if force < lightThreshold {
            // 【太輕區】：計算 0.0 到 0.9 之間的進度 (0% ~ 100%)
            let progress = Double(max(force, 0) / lightThreshold)
            
            // 讓色相從 0.6 (藍) 漸變到 0.33 (綠)
            let currentHue = blueHue - (progress * (blueHue - greenHue))
            return Color(hue: currentHue, saturation: 1.0, brightness: 1.0)
            
        } else if force > heavyThreshold {
            // 【太重區】：計算 2.1 到 3.0 之間的進度 (0% ~ 100%)
            let forceAboveThreshold = min(force, maxForce) - heavyThreshold
            let range = maxForce - heavyThreshold // 區間長度為 0.8
            let progress = Double(forceAboveThreshold / range)
            
            // 讓色相從 0.33 (綠) 漸變到 0.0 (紅)
            let currentHue = greenHue - (progress * (greenHue - redHue))
            return Color(hue: currentHue, saturation: 1.0, brightness: 1.0)
            
        } else {
            // 【完美區】：0.9 ~ 2.1 之間，穩穩地給純綠色
            return Color(hue: greenHue, saturation: 1.0, brightness: 1.0)
        }
    }
}
