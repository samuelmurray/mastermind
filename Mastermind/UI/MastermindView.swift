import SwiftUI


struct MastermindView: View {
    let game: Mastermind

    @State private var selection = 0
    @State private var restarting = false
    @State private var hideMostRecentMarkers = false

    var body: some View {
        VStack {
            CodeView(code: game.mastercode) {
                ElapsedTime(startTime: game.startTime, endTime: game.endTime, elapsedTime: game.elapsedTime)
                    .font(.system(size: 80))
                    .minimumScaleFactor(0.1)
                    .monospaced()
                    .lineLimit(1)
            }
            Spacer()
            ScrollView {
                if !game.isOver {
                    CodeView(code: game.guess, selection: $selection) {
                        guessButton
                    }
                    .animation(nil, value: game.attempts.count)
                    .opacity(restarting ? 0 : 1)
                }
                ForEach(game.attempts.reversed()) { attempt in
                    CodeView(code: attempt) {
                        let showMarkers = !hideMostRecentMarkers || attempt.id != game.attempts.last?.id
                        if showMarkers {
                            MatchMarkersView(matches: attempt.match(against: game.mastercode))
                        }
                    }
                    .transition(.attempt(game.isOver))
                }
            }
            if !game.isOver {
                PegChooserView(choices: game.pegChoices, onChoose: changePegAtSelection)
                    .transition(.pegChooser)
                    .frame(maxHeight: 90)
            }
        }
        .trackElapsedTime(in: game)
        .toolbar {
            Button("Restart", systemImage: "arrow.circlepath", action: restart)
        }
        .padding()
    }
    
    func changePegAtSelection(to peg: Peg) {
        game.setGuessPeg(peg, at: selection)
        selection = (selection + 1) % game.guess.pegs.count
    }
    
    var guessButton: some View {
        Button("Guess", action: guess)
            .font(.system(size: 80))
            .minimumScaleFactor(0.1)
            .lineLimit(1)
            .disabled(game.guess.pegs.contains{$0 == Code.missingPeg})
    }
    
    func guess() {
        withAnimation(.guess) {
            game.makeGuess()
            selection = 0
            hideMostRecentMarkers = true
        } completion: {
            withAnimation {
                hideMostRecentMarkers = false
            }
        }
    }
    
    func restart()  {
        withAnimation(.restart) {
            restarting = game.isOver
            game.restart()
            selection = 0
        } completion: {
            withAnimation(.restart) {
                restarting = false
            }
        }
    }
}

extension Animation {
    static let mastermind = Animation.default
    static let guess = Animation.mastermind
    static let restart = Animation.mastermind
    static let selection = Animation.mastermind
}

extension AnyTransition {
    static let pegChooser = AnyTransition.offset(x: 0, y: 200)
    static func attempt(_ isOver: Bool) -> AnyTransition {
        AnyTransition.asymmetric(
            insertion: isOver ? .opacity : .move(edge: .top),
            removal: .move(edge: .trailing)
        )
    }
}

#Preview {
    NavigationStack {
        MastermindView(game: Mastermind(gameSize: 3, pegChoices: [.green, .blue, .yellow]))
    }
}
