//
//  NewGameSettings.swift
//  Mastermind
//
//  Created by Samuel Murray on 2026-01-17.
//

import SwiftUI

struct GameEditor: View {
    @Environment(\.dismiss) var dismiss
    @State private var gameSize: Int = 4
    @State private var pegChoices: [Row<Color>] = .init([.green, .red, .yellow])
    @State private var showInvalidGameAlert = false
    let onStart: ((Mastermind) -> Void)?
    
    var body: some View {
        NavigationStack {
            Form {
                VStack {
                    Stepper("Game size: \(gameSize)", value: $gameSize, in: 3...6)
                    CodeView(code: Code(kind: .master(isHidden: true), pegs: .init(repeating: .red, count: gameSize)))
                }
                PegColorChooser(minCount: 2, maxCount: 5, pegChoices: $pegChoices)
                PegChooserView(choices: pegChoices.map(\.content))
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Start", role: .confirm) {
                        let newGame = Mastermind(gameSize: gameSize, pegChoices: pegChoices.map(\.content))
                        guard newGame.isValid else {
                            showInvalidGameAlert = true
                            return
                        }
                        onStart?(newGame)
                        dismiss()
                    }
                    .alert("Invalid game", isPresented: $showInvalidGameAlert) {
                        Button("Ok", role: .cancel) {
                            showInvalidGameAlert = false
                        }
                    } message: {
                        Text("All colors must be unique, non-clear")
                    }
                }
            }
        }
    }
    
    private var numColors: Binding<Int> {
        Binding(
            get: {
                pegChoices.count
            },
            set: { newCount in
                if (newCount < pegChoices.count) {
                    pegChoices.removeLast(pegChoices.count - newCount)
                } else if (newCount > pegChoices.count) {
                    (pegChoices.count..<newCount).forEach { _ in
                        pegChoices.append(.init(content: .random))
                    }
                }
            }
        )
    }
}

extension Mastermind {
    var isValid: Bool {
        guard (pegChoices.allSatisfy { $0 != Code.missingPeg }) else {
            return false
        }
        let uniqueColors = Set(pegChoices).count
        return uniqueColors >= 2 && uniqueColors == pegChoices.count
    }
}

#Preview {
    GameEditor { _ in }
}
