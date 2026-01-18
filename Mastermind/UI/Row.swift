import Foundation
import SwiftUI

struct Row<Content>: Identifiable {
    var id = UUID()
    var content: Content
}

extension Array {
    init<Wrapped>(_ elements: [Wrapped]) where Element == Row<Wrapped> {
       self = elements.map { Row(content: $0) }
   }
}

extension Row: Equatable where Content: Equatable {
    
}
