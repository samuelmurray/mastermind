import Foundation

typealias Peg = Int

struct Mastermind: Observable {
    var mastercode: Code
    var guess: Code
    var attempts: [Code]
    let pegChoices: [Peg]
    
    init(gameSize: Int, numColors: Int) {
        self.mastercode = Mastermind.randomCode(ofLength: gameSize, numColors: numColors)
        self.guess = Mastermind.emptyGuess(gameSize)
        self.attempts = []
        self.pegChoices = Array(0..<numColors)
    }
    
    var isOver: Bool {
        attempts.last?.pegs == mastercode.pegs
    }
    
    mutating func restart() {
        self.mastercode = randomizeCode()
        self.guess = Mastermind.emptyGuess(guess.pegs.count)
        self.attempts = []
    }
    
    mutating func updateGuess(at index: Int) {
        var guessPegs = guess.pegs
        guessPegs[index] = (guess.pegs[index] + 1) % pegChoices.count
        guess = Code(kind: .guess, pegs: guessPegs)
    }
    
    mutating func makeGuess() {
        attempts.append(Code(kind: .attempt, pegs: guess.pegs))
        guess = Mastermind.emptyGuess(guess.pegs.count)
        if (isOver) {
            mastercode = Code(kind: .master(isHidden: false), pegs: mastercode.pegs)
        }
    }
    
    mutating func setGuessPeg(_ peg: Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        var guessPegs = guess.pegs
        guessPegs[index] = peg
        guess = Code(kind: .guess, pegs: guessPegs)
    }

    func randomizeCode() -> Code {
        Mastermind.randomCode(ofLength: mastercode.pegs.count, numColors: pegChoices.count)
    }
    
    static func randomCode(ofLength: Int, numColors: Int) -> Code {
        let pegs = (0..<ofLength).map { _ in Int.random(in: 0..<numColors, ) }
        print(pegs)
        return Code(kind: .master(isHidden: true), pegs: pegs)
    }
    
    private static func emptyGuess(_ gameSize: Int) -> Code {
        return Code(kind: .guess, pegs: .init(repeating: -1, count: gameSize))
    }
}

enum Match {
    case nomatch
    case inexact
    case exact
}
