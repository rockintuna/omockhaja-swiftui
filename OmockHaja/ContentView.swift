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
        
    var body: some View {
        VStack {
            if webSocketManager.connected {
                if webSocketManager.matched {
                    if matchingReady {
                        GoBoardView()
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
    let message: String
    
    var body: some View {
        Text(message)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

import SwiftUI

struct StonePosition: Hashable {
    let row: Int
    let col: Int
}

struct GoBoardView: View {
    let boardSize = 19
    let cellSize: CGFloat = 20
    @State private var stones: Set<StonePosition> = []
    @State private var highlightedStone: StonePosition?
    @State private var isMyTurn: Bool = false // 내 턴인지 아닌지 나타내는 상태
    
    var body: some View {
        VStack {
            ZStack {
                // 바둑판 (격자)
                VStack(spacing: 0) {
                    ForEach(0..<boardSize, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<boardSize, id: \.self) { col in
                                BoardCellView(size: cellSize)
                            }
                        }
                    }
                }
                
                // 미리보기 돌 (회색 원)
                if let highlight = highlightedStone {
                    StoneView(color: .yellow, size: cellSize * 0.8)
                        .position(x: CGFloat(highlight.col) * cellSize,
                                  y: CGFloat(highlight.row) * cellSize)
                }
                
                // 실제 돌들
                ForEach(Array(stones), id: \.self) { stone in
                    StoneView(color: .black, size: cellSize * 0.8)
                        .position(x: CGFloat(stone.col) * cellSize,
                                  y: CGFloat(stone.row) * cellSize)
                }
            }
            .frame(width: CGFloat(boardSize - 1) * cellSize,
                   height: CGFloat(boardSize - 1) * cellSize)
            .padding()
            .background(Color.brown)
            .onTapGesture { location in
                let row = Int(round(location.y / cellSize))
                let col = Int(round(location.x / cellSize))
                highlightedStone = StonePosition(row: row, col: col)
            }
            
            // 방향키 버튼으로 미리보기 돌 위치 변경 (왼쪽에 배치, 크기 크게)
            HStack {
                VStack {
                    Button("↑") {
                        movePreviewStone(rowDelta: -1, colDelta: 0)
                    }
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.leading, 20)
                    
                    
                    HStack {
                        Button("←") {
                            movePreviewStone(rowDelta: 0, colDelta: -1)
                        }
                        .frame(width: 60, height: 60)
                        .font(.title)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.trailing, 60)
                        .padding(.leading, 20)
                        
                        Button("→") {
                            movePreviewStone(rowDelta: 0, colDelta: 1)
                        }
                        .frame(width: 60, height: 60)
                        .font(.title)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    Button("↓") {
                        movePreviewStone(rowDelta: 1, colDelta: 0)
                    }
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.leading, 20)
                }
                
                Spacer()
                
                // 확인 버튼 (오른쪽에 배치)
                Button("확인") {
                    if let highlight = highlightedStone {
                        if !stones.contains(highlight) {
                            stones.insert(highlight)
                            isMyTurn.toggle()
                        }
                        highlightedStone = nil
                    }
                }
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(10)
                .frame(width: 160, height: 60)
                .disabled(!isMyTurn)
            }
        }
    }
    
    // 미리보기 돌 이동 함수
    func movePreviewStone(rowDelta: Int, colDelta: Int) {
        guard var highlight = highlightedStone else { return }
        
        let newRow = max(0, min(boardSize - 1, highlight.row + rowDelta))
        let newCol = max(0, min(boardSize - 1, highlight.col + colDelta))
        
        highlightedStone = StonePosition(row: newRow, col: newCol)
    }
}

// 격자(Cell) View
struct BoardCellView: View {
    var size: CGFloat
    
    var body: some View {
        Rectangle()
            .stroke(Color.black, lineWidth: 1)
            .frame(width: size, height: size)
    }
}

// 바둑돌 View
struct StoneView: View {
    var color: Color
    var size: CGFloat
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
    }
}

struct GoBoardView_Previews: PreviewProvider {
    static var previews: some View {
        GoBoardView()
    }
}
