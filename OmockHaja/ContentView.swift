//
//  ContentView.swift
//  OmockHaja
//
//  Created by 이정인 on 2024/06/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var webSocketManager = WebSocketManager()
    @State var matchingReady = false;
    @State private var isGameOver: Bool = false // 승리 여부 상태 추가
    @State private var didWin: Bool = false
        
    var body: some View {
        VStack {
            if isGameOver {
                GameOverView(win: didWin) {
                    goMainView()
                }
            } else {
                if webSocketManager.connected {
                    if webSocketManager.matched {
                        if matchingReady {
                            GoBoardView(webSocketManager: webSocketManager, isGameOver: $isGameOver, didWin: $didWin)
                        } else {
                            WaitingView(
                                message: "상대방과 연결하는 중..."
                            ).onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    matchingReady = true
                                }
                            }
                        }
                    } else {
                        WaitingView(message: "상대방을 찾는 중...")
                    }
                
                } else {
                    MainView(webSocketManager: webSocketManager)
                }
            }
        }
    }
    
    private func goMainView() {
        isGameOver = false
        matchingReady = false
        webSocketManager.resetGame()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
