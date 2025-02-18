//
//  ContentView.swift
//  OmockHaja
//
//  Created by 이정인 on 2024/06/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var webSocketManager = WebSocketManager()
    @State private var showWaitingView = false;
        
    var body: some View {
        VStack {
            if webSocketManager.connected {
                WaitingView()
            } else {
                MainView(webSocketManager: webSocketManager)  // ✅ 동일한 인스턴스를 넘겨줌
            }
        }
    }
}

struct MainView: View {
    @ObservedObject var webSocketManager: WebSocketManager
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "circle.fill")
                    .imageScale(.large)
                    .foregroundColor(.black)
                Image(systemName: "circle")
                    .imageScale(.large)
                    .foregroundColor(.black)
                Image(systemName: "circle")
                    .imageScale(.large)
                    .foregroundColor(.black)
                Image(systemName: "circle")
                    .imageScale(.large)
                    .foregroundColor(.black)
                Image(systemName: "circle.fill")
                    .imageScale(.large)
                    .foregroundColor(.black)
            }
            
            Text("오목하자")
                .font(.largeTitle)
                .fontWeight(.regular)
                .foregroundColor(Color.black)
                .padding(.bottom, 50)
                .padding(10)
            
            Button {
                webSocketManager.connect()
            } label: {
                Text("시작하기")
                    .foregroundColor(Color.white)
                    .padding(10)
                    .background(.black)
                    .cornerRadius(13)
            }
        }
    }
}

struct WaitingView: View {
    var body: some View {
        Text("상대방을 찾는 중")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
