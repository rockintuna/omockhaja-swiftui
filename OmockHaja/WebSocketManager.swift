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
    @Published var matchId: String = ""
    @Published var newStone: StonePosition?
    @Published var win: Bool?
    
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
            let parts = message.split(separator: ":")
            color = String(parts[1])
            matchId = String(parts[2])
            print(matchId)
        }
        if message.hasPrefix("update:") {
            print(message)
            let parts = message.split(separator: ":")
            guard parts.count > 4,
                  let row = Int(parts[3]), let col = Int(parts[4]) else {
                print("Error: Invalid message format")
                return
            }

            if parts[2] == "B" {
                newStone = StonePosition(color: .black, row: row, col: col)
            } else {
                newStone = StonePosition(color: .white, row: row, col: col)
            }
        }
        if message.hasPrefix("win") {
            win = true
        }
        if message.hasPrefix("loose") {
            win = false
        }
    }
    
    func sendStonePosition(_ row: Int, _ col: Int) {
        print("send stone position message.")
        let payload = "\(self.matchId):\(color!):\(row):\(col)"
        let message = URLSessionWebSocketTask.Message.string(payload)
        
        webSocketTask?.send(message) { error in
            if let error = error {
                print("Error sending message: \(error)")
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
        webSocketTask = nil
    }
}
