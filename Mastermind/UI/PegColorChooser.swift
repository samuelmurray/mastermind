import SwiftUI

struct PegColorChooser: View {
    let minCount: Int
    let maxCount: Int
    @Binding var pegChoices: [Row<Color>]
    
    var body: some View {
        List {
            ForEach($pegChoices) { pegChoice in
                ColorPicker(selection: pegChoice.content, supportsOpacity: false) {
                    button("Peg Choice \(pegChoices.firstIndex{ $0.id == pegChoice.id }.map { $0 + 1 }, default: "?")", systemImage: "minus.circle", color: .red) {
                        pegChoices.removeAll{ $0.id == pegChoice.id }
                    }
                    .disabled(pegChoices.count <= minCount)
                }
                .transition(AnyTransition.move(edge: .top))
            }
            if (pegChoices.count < maxCount) {
                button("Add Peg", systemImage: "plus.circle", color: .green) {
                    pegChoices.append(.init(content: .random))
                }
            }
            
        }
    }
    
    func button(_ title: String, systemImage: String, color: Color? = nil, action: @escaping () -> Void) -> some View {
        HStack {
            Button {
                withAnimation {
                    action()
                }
            } label: {
                Image(systemName: systemImage)
                    .tint(color)
            }
            Text(title)
        }
    }
}

#Preview {
    @Previewable @State var pegChoices: [Row<Color>] = .init([Color.green, .brown])
    PegColorChooser(minCount: 1, maxCount: 5, pegChoices: $pegChoices)
        .onChange(of: pegChoices) {
            print("New peg choices: \(pegChoices)")
        }
}
