import SwiftUI
import SwiftData

struct SwiftDataPreview: PreviewModifier {
    let games: [Mastermind]
    
    init(with games: [Mastermind] = []) {
        self.games = games
    }
    
    static func makeSharedContext() async throws -> ModelContainer {
        let container = try ModelContainer(
            for: Mastermind.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
       
        return container
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        games.forEach { context.mainContext.insert($0) }
        return content.modelContainer(context)
    }
}

extension PreviewTrait<Preview.ViewTraits> {
    @MainActor static var swiftData: Self = .modifier(SwiftDataPreview())
    
    @MainActor static func swiftData(with games: [Mastermind] = []) -> Self {
        .modifier(SwiftDataPreview(with: games))
    }
}
