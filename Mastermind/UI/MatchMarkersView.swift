import SwiftUI

struct MatchMarkersView: View {
    let matches: [Match]
    
    var body: some View {
        VStack {
            HStack {
                ForEach((0..<matches.count / 2), id: \.self) { index in
                    matchMarker(peg: index)
                }
            }
            HStack {
                ForEach(matches.count / 2..<matches.count, id: \.self) { index in
                    matchMarker(peg: index)
                }
            }
        }
    }
    func matchMarker(peg: Int) -> some View {
        let exactCount = matches.count { $0 == .exact }
        let foundCount = matches.count { $0 != .nomatch }
        return Circle()
            .fill(exactCount > peg ? Color.primary : Color.clear)
            .strokeBorder(foundCount > peg ? Color.primary : Color.clear, lineWidth: 2)
    }
}

#Preview {
    MatchMarkersView(matches: [.exact,.exact,.nomatch,.inexact]).aspectRatio(1, contentMode: .fit).padding()
}
