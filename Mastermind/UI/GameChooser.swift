import SwiftUI

struct GameChooser: View {
    @State var games: [Mastermind] = []
    @State private var path = NavigationPath()
    @State private var selection: Mastermind? = nil
    @State private var showGameEditor = false

    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            List(selection: $selection) {
                Section("History") {
                    GameHistory(games: $games, selection: $selection)
                }
            }
            .onChange(of: games) {
                if let selection, !games.contains(selection) {
                    self.selection = nil
                }
            }
            .toolbar {
                Button("New game", systemImage: "plus") {
                    showGameEditor = true
                }
                .sheet(isPresented: $showGameEditor) {
                    GameEditor { game in
                        withAnimation {
                            games.insert(game, at: 0)
                            selection = game
                            showGameEditor = false
                        }
                    }
                }
                EditButton()
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
        .onAppear {
            if UIDevice.current.userInterfaceIdiom == .pad {
                selection = games.last
            }
        }
    }
}

#Preview {
    let game1 = Mastermind(gameSize: 3, numColors: 4)
    let game2 = Mastermind(gameSize: 4, numColors: 3)
    GameChooser(games: [game1, game2])
}
