import SwiftUI

@main
struct MastermindApp: App {
    var body: some Scene {
        WindowGroup {
            MastermindView(game: Mastermind(gameSize: 3, numColors: 3))
        }
    }
}
