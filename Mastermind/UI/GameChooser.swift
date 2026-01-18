import SwiftUI
import SwiftData

struct GameChooser: View {
    @Environment(\.modelContext) var modelContext
    @State private var editMode: EditMode = .inactive // Manual editMode to disable "+" button
    @State private var path = NavigationPath()
    @State private var selection: Mastermind? = nil
    @State private var showGameEditor = false
    @State private var filterOption: GameHistory.FilterOption = .all

    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            List(selection: $selection) {
                Section("History") {
                    Picker("Filter by", selection: $filterOption.animation(.default)) {
                        ForEach(GameHistory.FilterOption.allCases, id: \.self) { option in
                            Text(option.title)
                        }
                    }
                    .pickerStyle(.segmented)
                    GameHistory(filterBy: filterOption, selection: $selection)
                }
            }
            .environment(\.editMode, $editMode)
            .toolbar {
                Button("New game", systemImage: "plus") {
                    showGameEditor = true
                }
                .disabled(editMode.isEditing)
                .sheet(isPresented: $showGameEditor) {
                    GameEditor { game in
                        withAnimation {
                            modelContext.insert(game)
                            selection = game
                            showGameEditor = false
                        }
                    }
                }
                EditButton()
                    .environment(\.editMode, $editMode)
            }
            .navigationTitle("Mastermind")
        } detail: {
            if let selection {
                MastermindView(game: selection)
            } else {
                Text("Choose a game")
            }
        }
        .navigationSplitViewStyle(.balanced)
    }
}

#Preview(traits: .swiftData(with: [
    Mastermind(gameSize: 4, pegChoices: [.blue, .green, .red]),
    Mastermind(gameSize: 3, pegChoices: [.green, .brown, .yellow])
])) {
    GameChooser()
}
