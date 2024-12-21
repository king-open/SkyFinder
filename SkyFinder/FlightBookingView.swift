import SwiftUI

struct FlightBookingView: View {
    // 使用静态颜色属性
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
                    Text("预订您的\n下一趟航班")
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
                .background(Color.cardWhite)  // 使用静态颜色属性
                .clipShape(RoundedRectangle(cornerRadius: 24))
                
                // 日期和筛选按钮
                HStack(spacing: 12) {
                    Button {
                        // 日期选择动作
                    } label: {
                        NavigationLink {
                            SeatSelectionView(
                                departure: fromAirport,
                                arrival: toAirport,
                                departureTime: "03:00 AM",
                                arrivalTime: "09:00 AM",
                                price: "$120.00",
                                airline: "AIRBUS"
                            )
                        } label: {
                            HStack {
                                Text("出发")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.6))
                                Text("3月12日, 周二")
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.accentBlue)
                            .clipShape(Capsule())
                        }
                    }
                    
                    Button {
                        // 返程选择
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                                .foregroundColor(Color.accentBlue)
                            Text("返程")
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
                Text("搜索结果")
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
                            isHighlighted: true,
                            cardBackground: Color.cardWhite  // 使用静态颜色属性
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
                            isHighlighted: false,
                            cardBackground: Color.cardWhite  // 使用静态颜色属性
                        )
                    }
                }
            }
            .padding()
            .background(Color.backgroundBlue)  // 使用静态颜色属性
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
                .fill(Color(hex: "021324"))  // 使用深蓝色背景
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
    let cardBackground: Color
    
    var body: some View {
        NavigationLink {
            // 所有航班都显示登机牌界面
            BoardingPassView(
                flightNumber: "AB 4723211",
                departure: departure,
                arrival: arrival,
                departureCity: arrival == "JFK" ? "巴黎, 法国" : "巴黎, 法国",
                arrivalCity: arrival == "JFK" ? "纽约, 美国" : "都柏林, 爱尔兰",
                boardingTime: "01:20 AM",
                departureTime: departureTime,
                arrivalTime: arrivalTime,
                date: "3月12日, 周二",
                flightClass: "经济舱",
                passengerName: "张三",
                terminal: "1",
                gate: "37",
                seat: "1C",
                airline: airline
            )
        } label: {
            VStack(spacing: 16) {
                // 航线和价格
                HStack(alignment: .center) {
                    Text(departure)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Image(systemName: "arrow.right")
                        .foregroundColor(isHighlighted ? .white : .gray)
                        .padding(.horizontal, 4)
                    
                    Text(arrival)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Text(price)
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                // 时间信息
                HStack {
                    Text(departureTime)
                    Image(systemName: "arrow.right")
                        .font(.caption)
                    Text(arrivalTime)
                    
                    Spacer()
                    
                    Text(airline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(isHighlighted ? Color.black.opacity(0.3) : Color.gray.opacity(0.1))
                        .clipShape(Capsule())
                }
                .foregroundColor(isHighlighted ? .white.opacity(0.8) : .gray)
                
                // 时长和中转
                HStack {
                    Text(duration)
                    if !transfers.isEmpty {
                        Text(transfers)
                            .foregroundColor(isHighlighted ? .white : .accentBlue)
                    }
                }
                .font(.subheadline)
                .foregroundColor(isHighlighted ? .white.opacity(0.8) : .gray)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(isHighlighted ? Color.accentBlue : cardBackground)  // 使用传入的卡片背景色
            .foregroundColor(isHighlighted ? .white : .black)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

#Preview {
    FlightBookingView()
} 
