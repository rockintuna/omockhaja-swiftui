//
//  StoneView.swift
//  OmockHaja
//
//  Created by 이정인 on 2/21/25.
//
import SwiftUI

// 바둑돌 View
struct StoneView: View {
    var color: Color
    var size: CGFloat
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
    }
}
