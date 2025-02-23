//
//  StonePosition.swifto
//  OmockHaja
//
//  Created by 이정인 on 2/21/25.
//
import SwiftUI

struct StonePosition: Hashable {
    let color: Color
    let row: Int
    let col: Int
    
    static func == (lhs: StonePosition, rhs: StonePosition) -> Bool {
        return lhs.row == rhs.row && lhs.col == rhs.col
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(row)
        hasher.combine(col)
    }
}
