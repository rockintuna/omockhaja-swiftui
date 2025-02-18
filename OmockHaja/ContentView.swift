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
            Text(String(webSocketManager.connected))
            if webSocketManager.connected {
                WaitingView()
            } else {
                MainView()
            }
        }
    }
}

struct MainView: View {
    var webSocketManager = WebSocketManager()
    
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
        Text("This is the Detail View")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
