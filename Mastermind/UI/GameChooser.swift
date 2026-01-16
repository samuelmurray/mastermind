import SwiftUI

struct GameChooser: View {
    @State var games: [Mastermind] = []
    @State private var path = NavigationPath()
    @State private var gameSize: Int = 4
    @State private var numColors: Int = 4
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                Section("New game") {
                    let newGame = Mastermind(gameSize: gameSize, numColors: numColors)
                    VStack {
                        Stepper("Game size: \(gameSize)", value: $gameSize, in: 3...6)
                        CodeView(code: newGame.mastercode)
                    }
                    VStack {
                        Stepper("Number of colors: \(numColors)", value: $numColors, in: 3...6)
                        PegChooserView(choices: newGame.pegChoices, onChoose: nil)
                    }
                    Button("Start") {
                        let newGame = Mastermind(gameSize: gameSize, numColors: numColors)
                        games.append(newGame)
                        path.append(newGame)
                    }
                }
                
                Section("History") {
                    ForEach(games) { game in
                        NavigationLink(value: game) {
                            GameSummary(game: game)
                        }
                    }
                    .onDelete { offsets in
                        games.remove(atOffsets: offsets)
                    }
                    .onMove { from, to in
                        games.move(fromOffsets: from, toOffset: to)
                    }
                }
            }
            .navigationDestination(for: Mastermind.self) { game in
                MastermindView(game: game)
            }
            .toolbar {
                EditButton()
            }
        }
    }
}

#Preview {
    var game1 = Mastermind(gameSize: 3, numColors: 4)
    var game2 = Mastermind(gameSize: 4, numColors: 3)
    GameChooser(games: [game1, game2])
}
