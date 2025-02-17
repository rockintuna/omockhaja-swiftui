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
    
    @Published var receivedMessage: String?
    
    func connect() {
        let url = URL(string: "ws://localhost:8080")!
        let webSocketTask = URLSession.shared.webSocketTask(with: url)
        self.webSocketTask = webSocketTask
        webSocketTask.resume()
    }
    
    func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("Error receiving message: \(error)")
            case .success(.string(let message)):
                DispatchQueue.main.async {
                    self?.receivedMessage = message
                }
                self?.receiveMessage() // continue listening for new messages
            case .success:
                break // handle other message types
            }
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
    }
}
