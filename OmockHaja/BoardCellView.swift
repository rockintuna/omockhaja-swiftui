//
//  BoardCellView.swift
//  OmockHaja
//
//  Created by 이정인 on 2/21/25.
//
import SwiftUI

// 격자(Cell) View
struct BoardCellView: View {
    var size: CGFloat
    
    var body: some View {
        Rectangle()
            .stroke(Color.black, lineWidth: 1)
            .frame(width: size, height: size)
    }
}
