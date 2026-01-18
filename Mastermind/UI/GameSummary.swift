//
//  GameSummary.swift
//  Mastermind
//
//  Created by Samuel Murray on 2026-01-16.
//

import SwiftUI

struct GameSummary: View {
    let game: Mastermind
    
    var body: some View {
        VStack(alignment: .leading) {
            CodeView(code: game.mastercode)
            PegChooserView(choices: game.pegChoices, onChoose: nil)
            Text("^[\(game.attempts.count) attempt](inflect: true)")
        }
    }
}

#Preview {
    List {
        GameSummary(game: Mastermind(gameSize: 4, pegChoices: [.teal, .cyan, .yellow]))
    }
}
