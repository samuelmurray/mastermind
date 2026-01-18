import SwiftUI
import SwiftData

struct GameHistory: View {
    @Environment(\.modelContext) var modelContext
    @Query private var games: [Mastermind]
    @Binding var selection: Mastermind?
    
    init(filterBy: FilterOption = .all, selection: Binding<Mastermind?>) {
        _selection = selection
        switch filterBy {
        case .all: _games = Query(sort: \Mastermind.creationDate, order: .reverse)
        case .completed: _games = Query(
            filter: #Predicate { $0.isOver },
            sort: \Mastermind.creationDate,
            order: .reverse)
        case .uncompleted: _games = Query(
            filter: #Predicate { !$0.isOver },
            sort: \Mastermind.creationDate,
            order: .reverse
        )
        }
    }
    
    var body: some View {
        ForEach(games) { game in
            NavigationLink(value: game) {
                GameSummary(game: game)
                    .padding()
            }
            .contextMenu {
                deleteButton(for: game)
            }
        }
        .onDelete { offsets in
            for offset in offsets {
                withAnimation {
                    modelContext.delete(games[offset])
                }
            }
        }
        .onChange(of: games) {
            if let selection, !games.contains(selection) {
                self.selection = nil
            }
        }
        .onAppear {
            if UIDevice.current.userInterfaceIdiom == .pad {
                selection = games.first
            }
        }
    }
    
    func deleteButton(for game: Mastermind) -> some View {
        Button("Delete", systemImage: "minus.circle", role: .destructive) {
            withAnimation {
                modelContext.delete(game)
            }
        }
    }
    
    enum FilterOption: CaseIterable {
        case all
        case completed
        case uncompleted
        
        var title: String {
            switch self {
            case .all: "All"
            case .completed: "Completed"
            case .uncompleted: "Uncompleted"
            }
        }
    }
}

#Preview(traits: .swiftData(with: [Mastermind(gameSize: 4, pegChoices: [.blue, .green, .red]), Mastermind(gameSize: 3, pegChoices: [.blue, .green, .red])])) {
    NavigationStack {
        GameHistory(selection: .constant(nil))
    }
}
