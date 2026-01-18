import SwiftUI

struct PegChooserView: View {
    let choices: [Peg]
    let onChoose: ((Peg) -> Void)?
    
    var body: some View {
        HStack {
            ForEach(choices, id: \.self) { peg in
                Button {
                    onChoose?(peg)
                } label: {
                    PegView(peg: peg)
                }
            }
        }
    }
}

extension PegChooserView {
    init(choices: [Color], onChoose: ((Peg) -> Void)? = nil) {
        self.init(choices: choices.map(\.hexRGBA), onChoose: onChoose)
    }
}

#Preview {
    PegChooserView(choices: [Color.yellow, .red, .blue]) { _ in }.padding()
}
