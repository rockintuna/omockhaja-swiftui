//
//  WaitingView.swift
//  OmockHaja
//
//  Created by 이정인 on 2/21/25.
//
import SwiftUI

struct GameOverView: View {
    let win: Bool
    let onRestart: () -> Void
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text(win ? "You Win" : "You Lose")
                .font(.largeTitle)
                .padding()

            Button {
                onRestart()
            } label: {
                Text("메인으로")
                    .foregroundColor(Color.white)
                    .padding(10)
                    .background(Color.black)
                    .cornerRadius(13)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView(win: true, onRestart: {})
    }
}
