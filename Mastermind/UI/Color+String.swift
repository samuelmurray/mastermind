import SwiftUI

extension Color {
    init?(hexRGBA: String) {
        var hex = hexRGBA.trimmingCharacters(in: .whitespacesAndNewlines)
        hex = hex.replacingOccurrences(of: "#", with: "")
        
        guard hex.count == 8,
              let value = UInt64(hex, radix: 16) else {
            return nil
        }
        
        let r = Double((value >> 24) & 0xFF) / 255
        let g = Double((value >> 16) & 0xFF) / 255
        let b = Double((value >> 8) & 0xFF) / 255
        let a = Double(value & 0xFF) / 255
        
        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
    
    var hexRGBA: String {
        let uiColor = UIColor(self)
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return String(
            format: "#%02X%02X%02X%02X",
            Int(r * 255),
            Int(g * 255),
            Int(b * 255),
            Int(a * 255)
        )
    }
    
    static var random: Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}
