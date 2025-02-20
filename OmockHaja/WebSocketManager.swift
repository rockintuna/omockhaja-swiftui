//
//  WebSocketManager.swift
//  OmockHaja
//
//  Created by 이정인 on 2025/02/17.
//

import Foundation
import Combine

class WebSocketManager: ObservableObject {
    private var webSocketTask: URLSessionWebSocketTask?
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var connected: Bool = false
    @Published var matched: Bool = false
    @Published var matchId: String?
    
    //todo fix color : nil
    var color: String?
    
    func connect() {
        let url = URL(string: "ws://localhost:8080")!
        let webSocketTask = URLSession.shared.webSocketTask(with: url)
        print("websocket connect to " + url.absoluteString)
        self.webSocketTask = webSocketTask
        webSocketTask.resume()
        receiveMessage()
    }
    
    func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("Error receiving message: \(error)")
            case .success(.string(let message)):
                DispatchQueue.main.async {
                    self?.handleMessage(message)
                }
                self?.receiveMessage()
            case .success:
                print("binary data Received.")
                break
            }
        }
    }
    
    private func handleMessage(_ message: String) {
        if message == "hello" {
            print(message)
            connected = true
        }
        if message.hasPrefix("match:") {
            print(message)
            matched = true
            let colorIndex = message.index(message.startIndex, offsetBy: 6)
            color = String(message[colorIndex])

            let matchIdIndex = message.index(message.startIndex, offsetBy: 8)
            matchId = String(message[matchIdIndex...])
            print(matchId ?? "matchId: nil")
        }
    }
    
    func sendMessage(_ message: String) {
        let message = URLSessionWebSocketTask.Message.string(message)
        webSocketTask?.send(message) { error in
            if let error = error {
                print("Error sending message: \(error)")
            }
        }
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
    }
}
