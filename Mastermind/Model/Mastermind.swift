import Foundation
import SwiftData

typealias Peg = String

@Model class Mastermind {
    @Relationship(deleteRule: .cascade) var mastercode: Code
    @Relationship(deleteRule: .cascade) var guess: Code
    @Relationship(deleteRule: .cascade) var _attempts: [Code]
    var pegChoices: [Peg]
    var startTime: Date?
    var endTime: Date?
    var elapsedTime: TimeInterval = 0
    var creationDate: Date = Date.now
    var isOver: Bool = false
    
    init(gameSize: Int, pegChoices: [Peg]) {
        self.mastercode = Mastermind.randomCode(ofLength: gameSize, pegChoices: pegChoices)
        self.guess = Mastermind.emptyGuess(gameSize)
        self._attempts = []
        self.pegChoices = pegChoices
    }
    
    var attempts: [Code] {
        get {
            _attempts.sorted { $0.timestamp < $1.timestamp }
        }
        set {
            _attempts = newValue
        }
    }
    
    func restart() {
        mastercode = randomizeCode()
        guess = Mastermind.emptyGuess(guess.pegs.count)
        attempts.removeAll()
        startTime = .now
        endTime = nil
        elapsedTime = 0
        isOver = false
    }
    
    func makeGuess() {
        attempts.append(Code(kind: .attempt, pegs: guess.pegs))
        guess.pegs = .init(repeating: Code.missingPeg, count: guess.pegs.count)
        if attempts.last?.pegs == mastercode.pegs {
            isOver = true
            mastercode = Code(kind: .master(isHidden: false), pegs: mastercode.pegs)
            endTime = .now
        }
    }
    
    func setGuessPeg(_ peg: Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = peg
    }

    func randomizeCode() -> Code {
        Mastermind.randomCode(ofLength: mastercode.pegs.count, pegChoices: pegChoices)
    }

    func startTimer() {
        if startTime == nil, !isOver {
            startTime = .now
            //elapsedTime += 0.0000001 // Hack to make transient startTime trigger UI update
        }
    }
    
    func pauseTimer() {
        if let startTime, !isOver {
            elapsedTime += Date.now.timeIntervalSince(startTime)
            self.startTime = nil
        }
    }
    
    func updateElapsedTime() {
        pauseTimer()
        startTimer()
    }
    
    static func randomCode(ofLength: Int, pegChoices: [Peg]) -> Code {
        let pegs = (0..<ofLength).map { _ in pegChoices.randomElement()! }
        print(pegs.map{pegChoices.firstIndex(of: $0)})
        return Code(kind: .master(isHidden: true), pegs: pegs)
    }
    
    private static func emptyGuess(_ gameSize: Int) -> Code {
        return Code(kind: .guess, pegs: .init(repeating: Code.missingPeg, count: gameSize))
    }
}

enum Match {
    case nomatch
    case inexact
    case exact
}
