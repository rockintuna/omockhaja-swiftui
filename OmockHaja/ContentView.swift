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
    let color: Color
    let row: Int
    let col: Int
}

struct GoBoardView: View {
    let boardSize = 19
    let cellSize: CGFloat = 20
    
    @ObservedObject var webSocketManager = WebSocketManager()
    @State private var stones: Set<StonePosition> = []
    @State private var highlightedStone: StonePosition?
    @State private var isMyTurn: Bool = false // 내 턴인지 아닌지 나타내는 상태
    @State private var myColor: Color?
    
    var body: some View {
        VStack {
            ZStack {
                //
                if isMyTurn {
                    Text("내 차례")
                } else {
                    Text("상대 차례")
                }
                
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
                    StoneView(color: stone.color, size: cellSize * 0.8)
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
                highlightedStone = StonePosition(color: .yellow, row: row, col: col)
            }
            .onAppear {
                print("GoBoardView가 화면에 나타남!")
                print(String(webSocketManager.color ?? "color : nil"))
                if webSocketManager.color == "B" {
                    print("흑돌")
                    isMyTurn = true
                    myColor = .black
                    let _ = print("isMyTurn: ", isMyTurn)
                } else {
                    print("백돌")
                    myColor = .white
                }
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
                        let stoneColor: Color = myColor ?? .black
                        let newStone = StonePosition(color: stoneColor, row: highlight.row, col: highlight.col)

                        if !stones.contains(newStone) {
                            stones.insert(newStone)
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
        
        highlightedStone = StonePosition(color: .yellow, row: newRow, col: newCol)
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
