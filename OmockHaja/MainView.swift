//
//  MainView.swift
//  OmockHaja
//
//  Created by 이정인 on 2/21/25.
//
import SwiftUI

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
                    .background(Color.black)
                    .cornerRadius(13)
            }.buttonStyle(PlainButtonStyle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // 전체 화면을 차지하도록 설정
        .background(Color.white) // 배경색을 흰색으로 설정
        .ignoresSafeArea() // 안전 영역을 무시하고 전체 화면 적용
    }
}
