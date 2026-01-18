import SwiftUI
import SwiftData

@main
struct MastermindApp: App {
    var body: some Scene {
        WindowGroup {
            GameChooser()
                .modelContainer(for: Mastermind.self)
        }
    }
}
