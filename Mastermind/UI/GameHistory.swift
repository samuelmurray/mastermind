//
//  GameHistory.swift
//  Mastermind
//
//  Created by Samuel Murray on 2026-01-17.
//

import SwiftUI

struct GameHistory: View {
    @Binding var games: [Mastermind]
    @Binding var selection: Mastermind?
    
    var body: some View {
        ForEach(games) { game in
            NavigationLink(value: game) {
                GameSummary(game: game)
            }
            .contextMenu {
                deleteButton(for: game)
            }
        }
        .onDelete { offsets in
            games.remove(atOffsets: offsets)
        }
        .onMove { from, to in
            games.move(fromOffsets: from, toOffset: to)
        }
    }
    
    func deleteButton(for game: Mastermind) -> some View {
        Button("Delete", systemImage: "minus.circle", role: .destructive) {
            withAnimation {
                games.removeAll { $0 == game }
            }
        }
    }
}

#Preview {
    @Previewable @State var games: [Mastermind] = [Mastermind(gameSize: 4, numColors: 3), Mastermind(gameSize: 5, numColors: 4)]
    NavigationStack {
        GameHistory(games: $games, selection: .constant(nil))
    }
}
