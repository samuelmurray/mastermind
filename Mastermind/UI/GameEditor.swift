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
    @State private var numColors: Int = 4
    let onStart: ((Mastermind) -> Void)?
    
    var body: some View {
        let newGame = Mastermind(gameSize: gameSize, numColors: numColors)
        NavigationStack {
            Form {
                VStack {
                    Stepper("Game size: \(gameSize)", value: $gameSize, in: 3...6)
                    CodeView(code: newGame.mastercode)
                }
                VStack {
                    Stepper("Number of colors: \(numColors)", value: $numColors, in: 3...6)
                    PegChooserView(choices: newGame.pegChoices, onChoose: nil)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Start", role: .confirm) {
                        let newGame = Mastermind(gameSize: gameSize, numColors: numColors)
                        onStart?(newGame)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    GameEditor { _ in }
}
