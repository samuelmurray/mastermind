import SwiftUI

struct ElapsedTime: View {
    let startTime: Date?
    let endTime: Date?
    let elapsedTime: TimeInterval
    
    var body: some View {
        if let startTime {
            if let endTime {
                Text(endTime, format: .offset(to: startTime - elapsedTime, allowedFields: [.minute, .second]))
            }
            else {
                Text(TimeDataSource<Date>.currentDate, format: .offset(to: startTime - elapsedTime, allowedFields: [.minute, .second]))
            }
        } else {
            Image(systemName: "pause")
        }
    }
}

#Preview {
    ElapsedTime(startTime: .now, endTime: nil, elapsedTime: 10)
}
