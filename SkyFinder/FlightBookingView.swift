import SwiftUI

struct FlightBookingView: View {
    @State private var fromAirport = "CDG"
    @State private var toAirport = "JFK"
    @State private var fromCity = "Paris, France"
    @State private var toCity = "New York, USA"
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                // 顶部区域
                HStack {
                    Text("Let's book your\nnext flight")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    // 通知和头像
                    HStack(spacing: 12) {
                        Circle()
                            .strokeBorder(.white.opacity(0.2), lineWidth: 1)
                            .frame(width: 40, height: 40)
                            .overlay {
                                Circle()
                                    .fill(Color.accentBlue)
                                    .frame(width: 12, height: 12)
                                    .offset(x: 8, y: -8)
                                Image(systemName: "bell")
                                    .foregroundColor(.white)
                            }
                        
                        Circle()
                            .fill(.gray.opacity(0.2))
                            .frame(width: 40, height: 40)
                            .overlay {
                                Image("profile")
                                    .resizable()
                                    .clipShape(Circle())
                            }
                    }
                }
                
                // 机场选择区域
                VStack(spacing: 0) {
                    AirportSelectionView(label: "From", code: fromAirport, city: fromCity)
                    AirportSelectionView(label: "To", code: toAirport, city: toCity)
                }
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                
                // 日期和筛选按钮
                HStack(spacing: 12) {
                    Button {
                        // 日期选择动作
                    } label: {
                        HStack {
                            Text("Departure")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.6))
                            Text("March 12, Tue")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accentBlue)
                        .clipShape(Capsule())
                    }
                    
                    Button {
                        // 返程选择
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                                .foregroundColor(Color.accentBlue)
                            Text("Return")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .overlay {
                            Capsule()
                                .strokeBorder(Color.accentBlue.opacity(0.5), style: StrokeStyle(lineWidth: 1, dash: [4]))
                        }
                    }
                    
                    Button {
                        // 筛选动作
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .padding()
                            .background(Color.accentBlue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                }
                
                // 结果标题
                Text("Results")
                    .font(.title2)
                    .fontWeight(.bold)
                
                // 航班结果列表
                ScrollView {
                    VStack(spacing: 12) {
                        FlightResultCard(
                            departure: "CDG",
                            arrival: "DUB",
                            departureTime: "02:00 AM",
                            arrivalTime: "06:00 AM",
                            duration: "12 hr",
                            transfers: "1 transfer",
                            price: "$120.00",
                            airline: "airTran",
                            isHighlighted: true
                        )
                        
                        FlightResultCard(
                            departure: "CDG",
                            arrival: "JFK",
                            departureTime: "02:00 AM",
                            arrivalTime: "10:00 AM",
                            duration: "8 hr",
                            transfers: "no transfers",
                            price: "$120.00",
                            airline: "AIRBUS",
                            isHighlighted: false
                        )
                    }
                }
            }
            .padding()
            .background(Color(red: 0.06, green: 0.06, blue: 0.06))
        }
        .preferredColorScheme(.dark)
    }
}

struct AirportSelectionView: View {
    let label: String
    let code: String
    let city: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(code)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Text(city)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Circle()
                .fill(Color(red: 0.06, green: 0.06, blue: 0.06))
                .frame(width: 40, height: 40)
                .overlay {
                    Image(systemName: "arrow.up.arrow.down")
                        .foregroundColor(.white)
                }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

struct FlightResultCard: View {
    let departure: String
    let arrival: String
    let departureTime: String
    let arrivalTime: String
    let duration: String
    let transfers: String
    let price: String
    let airline: String
    let isHighlighted: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("\(departure) → \(arrival)")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Text(price)
                    .font(.title3)
                    .fontWeight(.bold)
            }
            
            HStack {
                Text("\(departureTime) → \(arrivalTime)")
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text(airline)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(uiColor: .systemGray6))
                    .clipShape(Capsule())
            }
            
            HStack {
                Text(duration)
                if !transfers.isEmpty {
                    Text(transfers)
                        .foregroundColor(.accentBlue)
                }
            }
            .font(.subheadline)
        }
        .padding()
        .background(isHighlighted ? Color.accentBlue : Color(uiColor: .systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

extension Color {
    static let accentBlue = Color(red: 0.35, green: 0.55, blue: 1.0)
}

#Preview {
    FlightBookingView()
} 
