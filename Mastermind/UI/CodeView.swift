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
                    .overlay { // Selection
                        Group {
                            if code.kind == .guess, selection == index
                            {
                                Constants.pegShape(stroke: true)
                            }
                        }
                        .animation(.selection, value: selection)
                    }
                    .overlay { // Obfuscation
                        Constants.pegShape()
                            .foregroundStyle(code.isHidden ? obfuscationColor : Color.clear)
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
        colorScheme == .dark ? .white.opacity(1) : .black.opacity(1)
    }
}

#Preview {
    @Previewable @State var selection = 0
    let code = Code(kind: .guess, pegs: [-1, 0, 1])
    CodeView(code: code, selection: $selection) { EmptyView() }.padding()
}
