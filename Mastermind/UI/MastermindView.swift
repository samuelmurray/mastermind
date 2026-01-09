import SwiftUI


struct MastermindView: View {
    @State var game: Mastermind
    @State private var selection = 0
    @State private var restarting = false
    @State private var hideMostRecentMarkers = false

    var body: some View {
        VStack {
            Button("Restart", systemImage: "arrow.circlepath", action: restart)
            CodeView(code: game.mastercode)
            Spacer()
            ScrollView {
                if !game.isOver || restarting {
                    CodeView(code: game.guess, selection: $selection) {
                        guessButton
                    }
                    .animation(nil, value: game.attempts.count)
                    .opacity(restarting ? 0 : 1)
                }
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    CodeView(code: game.attempts[index]) {
                        let showMarkers = !hideMostRecentMarkers || index != game.attempts.count - 1
                        if showMarkers {
                            MatchMarkersView(matches: game.attempts[index].match(against: game.mastercode))
                        }
                    }
                    .transition(.attempt(game.isOver))
                }
            }
            if !game.isOver {
                PegChooserView(choices: game.pegChoices, onChoose: changePegAtSelection)
                    .transition(.pegChooser)
            }
        }.padding()
    }
    
    func changePegAtSelection(to peg: Peg) {
        game.setGuessPeg(peg, at: selection)
        selection = (selection + 1) % game.guess.pegs.count
    }
    
    var guessButton: some View {
        Button("Guess", action: guess)
            .font(.system(size: 80))
            .minimumScaleFactor(0.1)
            .disabled(game.guess.pegs.contains{$0 < 0})
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
            game.restart()
            selection = 0
            restarting = true
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

struct Constants {
    @ViewBuilder
    static func pegShape(stroke: Bool = false) -> some View {
        if stroke {
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(lineWidth: 5)
                .aspectRatio(1, contentMode: .fit)
        } else {
            RoundedRectangle(cornerRadius: 10)
                .aspectRatio(1, contentMode: .fit)
        }
    }
}

#Preview {
    MastermindView(game: Mastermind(gameSize: 3, numColors: 3))
}
