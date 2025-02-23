//
//  WaitingView.swift
//  OmockHaja
//
//  Created by 이정인 on 2/21/25.
//
import SwiftUI

struct GameOverView: View {
    let win: Bool
    
    var body: some View {
        if win {
            Text("You Win")
        } else {
            Text("You Loose")
        }
    }
}
