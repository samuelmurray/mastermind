import Foundation
import SwiftData

@Model class Code: Identifiable {
    var _kind: String = Kind.unknown.description
    var pegs: [Peg]
    var timestamp: Date = Date.now
    
    var kind: Kind {
        get {
            return Kind(_kind)
        }
        set {
            _kind = newValue.description
        }
    }
    
    init(kind: Kind, pegs: [Peg]) {
        self.pegs = pegs
        self.kind = kind
    }
    
    var isHidden: Bool {
        switch kind {
        case .master(let isHidden):
            return isHidden
        default:
            return false
        }
    }
    
    func match(against other: Code) -> [Match] {
        var results: [Match] = Array(repeating: .nomatch, count: pegs.count)
        var pegsToMatch = other.pegs
        for index in pegs.indices.reversed() {
            if pegsToMatch.count > index, pegsToMatch[index] == pegs[index] {
                results[index] = .exact
                pegsToMatch.remove(at: index)
            }
        }
        for index in pegs.indices {
            if results[index] != .exact {
                if let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
                    results[index] = .inexact
                    pegsToMatch.remove(at: matchIndex)
                }
            }
        }
        return results
    }
    
    enum Kind: Equatable, CustomStringConvertible {
        case master(isHidden: Bool)
        case guess
        case attempt
        case unknown
        
        var description: String {
            switch self {
            case .master(let isHidden):
                "master(\(isHidden))"
            case .guess:
                "guess"
            case .attempt:
                "attempt"
            case .unknown:
                "unknown"
            }
        }
        
        init(_ string: String) {
            switch string {
            case "guess":
                self = .guess
                return
            case "attempt":
                self = .attempt
                return
            default:
                if string.hasPrefix("master("), string.hasSuffix(")") {
                    let inner = String(string.dropFirst("master(".count)).dropLast()
                    switch inner {
                    case "true":
                        self = .master(isHidden: true)
                        return
                    case "false":
                        self = .master(isHidden: false)
                        return
                    default:
                        break
                    }
                }
                self = .unknown
            }
        }
    }
    
    static var missingPeg: Peg = ""
}
