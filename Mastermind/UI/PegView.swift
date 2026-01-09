let nullColor = Color.gray
let colors: [Color] = [.red, .blue, .green, .yellow, .purple, .brown]

import SwiftUI

struct PegView: View {
    let peg: Peg
        
    var body: some View {
        Constants.pegShape()
            .foregroundStyle(color(for: peg))
    }
    
    func color(for peg: Peg) -> Color {
        return peg < 0 ? nullColor : colors[peg]
    }
}

#Preview {
    PegView(peg: 0).padding()
    PegView(peg: 0).padding()
}
