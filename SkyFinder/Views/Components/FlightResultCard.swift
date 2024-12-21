import SwiftUI

struct FlightResultCard: View {
    let flight: Flight
    @State private var isHighlighted = false
    
    var body: some View {
        NavigationLink {
            BoardingPassView(flight: flight)
        } label: {
            VStack(spacing: 16) {
                // ... 卡片内容 ...
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(isHighlighted ? Color.accentBlue : Color.cardWhite)
            .foregroundColor(isHighlighted ? .white : .black)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
} 
