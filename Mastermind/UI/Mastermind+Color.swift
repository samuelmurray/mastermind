import SwiftUI

extension Mastermind {
    convenience init(gameSize: Int, pegChoices: [Color]) {
        self.init(gameSize: gameSize, pegChoices: pegChoices.map(\.hexRGBA))
    }
    
    var pegColorChoices: [Color] {
        get {
            pegChoices.map { Color.init(hexRGBA: $0) ?? Color.clear }
        }
        set {
            pegChoices = newValue.map(\.hexRGBA)
        }
    }
}

extension Code {
    convenience init(kind: Kind, pegs: [Color]) {
        self.init(kind: kind, pegs: pegs.map(\.hexRGBA))
    }
}
