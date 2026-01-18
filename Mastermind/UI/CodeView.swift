import SwiftUI

struct CodeView<AncillaryView>: View where AncillaryView: View {
    let code: Code
    @Binding var selection: Int
    let ancillaryView: () -> AncillaryView
    @Environment(\.colorScheme) private var colorScheme
    
    init(
        code: Code,
        selection: Binding<Int> = .constant(-1),
        @ViewBuilder ancillaryView: @escaping () -> AncillaryView = { EmptyView() }
    ) {
        self.code = code
        self._selection = selection
        self.ancillaryView = ancillaryView
    }
    
    var body: some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self) { index in
                PegView(peg: code.pegs[index])
                    .contentShape(Rectangle())
                    .overlay { // Selection
                        Group {
                            if code.kind == .guess, selection == index
                            {
                                PegView(peg: .clear, stroke: .primary)
                            }
                        }
                        .animation(.selection, value: selection)
                    }
                    .overlay { // Obfuscation
                        PegView(peg: code.isHidden ? obfuscationColor : Color.clear)
                            .transaction { transaction in
                                if code.isHidden {
                                    transaction.animation = nil
                                }
                            }
                    }
                    .onTapGesture {
                        if (selection >= 0) {
                            selection = index
                        }
                    }
            }
            Rectangle()
                .aspectRatio(1, contentMode: .fit)
                .foregroundStyle(.clear)
                .overlay {
                    ancillaryView()
                }
        }
    }
    
    var obfuscationColor: Color {
        colorScheme == .dark ? .white : .black
    }
}

#Preview {
    @Previewable @State var selection = 1
    let master = Code(kind: .master(isHidden: true), pegs: [.red, .blue, .green])
    CodeView(code: master) { Text("00:05") }.padding()
    let guess = Code(kind: .guess, pegs: [.red, .green, .clear])
    CodeView(code: guess, selection: $selection) { EmptyView() }.padding()
}
