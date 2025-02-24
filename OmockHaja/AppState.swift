//
//  AppState.swift
//  OmockHaja
//
//  Created by 이정인 on 2/24/25.
//


import SwiftUI

class AppState: ObservableObject {
    @Published var currentView: AppView = .content // 기본값을 ContentView로 설정

    enum AppView {
        case content
        case game
    }
}