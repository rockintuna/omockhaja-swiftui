//
//  GoBoardView.swift
//  OmockHaja
//
//  Created by 이정인 on 2/21/25.
//
import SwiftUI

struct GoBoardView: View {
    let boardSize = 19
    let cellSize: CGFloat = 20
    
    @ObservedObject var webSocketManager: WebSocketManager
    @State private var stones: Set<StonePosition> = []
    @State private var highlightedStone: StonePosition?
    @State private var isMyTurn: Bool = false // 내 턴인지 아닌지 나타내는 상태
    @State private var myColor: Color?
    @Binding var isGameOver: Bool
    @Binding var didWin: Bool
        
    var body: some View {
        VStack {
            gameBoardView
        }
        .onReceive(webSocketManager.$win) { win in
            if let win = win {
                isGameOver = true
                didWin = win
            }
        }
    }
    
    private var gameBoardView: some View {
        VStack {
            if isMyTurn {
                Text("내 차례")
            } else {
                Text("상대 차례")
            }
            ZStack {
                // 바둑판 (격자)
                VStack(spacing: 0) {
                    ForEach(0..<boardSize - 1, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<boardSize - 1, id: \.self) { col in
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
            .onReceive(webSocketManager.$newStone) { stone in
                if stone != nil {
                    isMyTurn = true
                    stones.insert(stone!)
                }
            }
            .frame(width: CGFloat(boardSize - 1) * cellSize,
                   height: CGFloat(boardSize - 1) * cellSize)
            .padding()
            .background(Color.brown)
            .onTapGesture { location in
                guard isMyTurn else { return } // 내 차례일 때만 실행
                let row = Int(round(location.y / cellSize) - 1)
                let col = Int(round(location.x / cellSize) - 1)
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
                    guard let highlight = highlightedStone else {return}

                    let stoneColor: Color = myColor ?? .black
                    let newStone = StonePosition(color: stoneColor, row: highlight.row, col: highlight.col)

                    if !stones.contains(newStone) {
                        stones.insert(newStone)
                        isMyTurn.toggle()
                        webSocketManager.sendStonePosition(highlight.row,highlight.col)
                    }
                    highlightedStone = nil
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
        guard let highlight = highlightedStone else { return }
        
        let newRow = max(0, min(boardSize - 1, highlight.row + rowDelta))
        let newCol = max(0, min(boardSize - 1, highlight.col + colDelta))
        
        highlightedStone = StonePosition(color: .yellow, row: newRow, col: newCol)
        print ("row", highlight.row)
        print ("col", highlight.col)
    }
}

struct GoBoardView_Previews: PreviewProvider {
    @State static var isGameOver = false
    @State static var didWin = false

    static var previews: some View {
        GoBoardView(
            webSocketManager: WebSocketManager(),
            isGameOver: $isGameOver,
            didWin: $didWin
        )
    }
}
