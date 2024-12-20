import SwiftUI

struct FlightBookingView: View {
    @State private var fromAirport = "CDG"
    @State private var toAirport = "JFK"
    @State private var fromCity = "Paris, France"
    @State private var toCity = "New York, USA"
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                // 顶部区域
                HStack {
                    Text("Let's book your\nnext flight")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    // 通知和头像
                    HStack(spacing: 12) {
                        Circle()
                            .fill(.blue)
                            .frame(width: 40)
                            .overlay {
                                Image(systemName: "bell")
                                    .foregroundColor(.white)
                            }
                        
                        Circle()
                            .fill(.gray.opacity(0.2))
                            .frame(width: 40)
                            .overlay {
                                Image("profile")
                                    .resizable()
                                    .clipShape(Circle())
                            }
                    }
                }
                
                // 机场选择区域
                VStack(spacing: 12) {
                    AirportSelectionView(label: "From", code: fromAirport, city: fromCity)
                    AirportSelectionView(label: "To", code: toAirport, city: toCity)
                }
                .padding()
                .background(Color(uiColor: .systemBackground))
                .cornerRadius(16)
                
                // 日期和筛选按钮
                HStack(spacing: 12) {
                    Button {
                        // 日期选择动作
                    } label: {
                        Text("March 12, Tue")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    
                    Button {
                        // 返程选择
                    } label: {
                        Text("Return")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background {
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(.blue, style: StrokeStyle(dash: [4]))
                            }
                    }
                    
                    Button {
                        // 筛选动作
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .padding()
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                
                // 结果标题
                Text("Results")
                    .font(.title2)
                    .fontWeight(.bold)
                
                // 航班结果列表
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
            .padding()
            .background(Color(uiColor: .systemBackground).brightness(-0.1))
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
            VStack(alignment: .leading) {
                Text(label)
                    .foregroundColor(.gray)
                Text(code)
                    .font(.title2)
                    .fontWeight(.bold)
                Text(city)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "arrow.up.arrow.down")
                .padding()
                .background(Color.black.opacity(0.8))
                .clipShape(Circle())
        }
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
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .center) {
                    Text(departure)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Image(systemName: "arrow.right")
                        .foregroundColor(.gray)
                    
                    Text(arrival)
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                HStack {
                    Text(departureTime)
                    Image(systemName: "arrow.right")
                        .foregroundColor(.gray)
                    Text(arrivalTime)
                }
                
                HStack {
                    Text(duration)
                    Text(transfers)
                        .foregroundColor(.blue)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 8) {
                Text(price)
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text(airline)
                    .padding(8)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(isHighlighted ? Color.blue : Color(uiColor: .systemBackground))
        .cornerRadius(16)
    }
}

#Preview {
    FlightBookingView()
} 
