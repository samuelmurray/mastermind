import SwiftUI

struct PegView: View {
    let peg: Peg
    let stroke: Color
    
    init(peg: Peg, stroke: Color = .clear) {
        self.peg = peg
        self.stroke = stroke
    }
        
    var body: some View {
        let color = Color(hexRGBA: peg) ?? .clear
        RoundedRectangle(cornerRadius: 10)
            .fill(color)
            .strokeBorder(stroke, lineWidth: 5)
            .aspectRatio(1, contentMode: .fit)
    }
}

extension PegView {
    init(peg: Color, stroke: Color = .clear) {
        self.init(peg: peg.hexRGBA, stroke: stroke)
    }
}

#Preview {
    PegView(peg: Color.blue)
        .padding()
    PegView(peg: Color.red)
        .overlay {
            PegView(peg: .clear, stroke: .primary)
        }
        .padding()
}
