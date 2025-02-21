struct GoBoardView: View {
    let boardSize = 19
    let cellSize: CGFloat = 20
    
    @ObservedObject var webSocketManager: WebSocketManager
    @State private var stones: Set<StonePosition> = []
    @State private var highlightedStone: StonePosition?
    @State private var isMyTurn: Bool = false // 내 턴인지 아닌지 나타내는 상태
    @State private var myColor: Color?
    
    var body: some View {
        VStack {
            if isMyTurn {
                Text("내 차례")
            } else {
                Text("상대 차례")
            }
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
                    StoneView(color: stone.color, size: cellSize * 0.8)
                        .position(x: CGFloat(stone.col) * cellSize,
                                  y: CGFloat(stone.row) * cellSize)
                }
            }
            .frame(width: CGFloat(boardSize) * cellSize,
                   height: CGFloat(boardSize) * cellSize)
            .padding()
            .background(Color.brown)
            .onTapGesture { location in
                guard isMyTurn else { return } // 내 차례일 때만 실행
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
        if highlightedStone != nil {
            print ("row", highlightedStone!.row)
            print ("col", highlightedStone!.col)
        }
    }
}
