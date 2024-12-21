import SwiftUI

struct FlightResultCard: View {
    let flight: Flight
    @State private var isHighlighted = false
    
    var body: some View {
        NavigationLink {
            BoardingPassView(flight: flight)
        } label: {
            VStack(spacing: 16) {
                // 航线和价格
                HStack(alignment: .center) {
                    Text(flight.departure)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Image(systemName: "arrow.right")
                        .foregroundColor(isHighlighted ? .white : .gray)
                        .padding(.horizontal, 4)
                    
                    Text(flight.arrival)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Text(flight.price)
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                // 时间信息
                HStack {
                    Text(flight.departureTime)
                    Image(systemName: "arrow.right")
                        .font(.caption)
                    Text(flight.arrivalTime)
                    
                    Spacer()
                    
                    Text(flight.airline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(isHighlighted ? Color.black.opacity(0.3) : Color.gray.opacity(0.1))
                        .clipShape(Capsule())
                }
                .foregroundColor(isHighlighted ? .white.opacity(0.8) : .gray)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(isHighlighted ? Color.accentBlue : Color.cardWhite)
            .foregroundColor(isHighlighted ? .white : .black)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
} 
