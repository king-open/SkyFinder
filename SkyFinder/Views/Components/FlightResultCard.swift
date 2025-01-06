import SwiftUI

struct FlightResultCard: View {
    let flight: Flight
    var mode: DisplayMode = .search
    @State private var isHighlighted = false
    @State private var showingPayment = false
    @State private var showingDetail = false
    @EnvironmentObject var viewModel: FlightBookingViewModel
    
    enum DisplayMode {
        case search
        case order
    }
    
    var body: some View {
        Button {
            if mode == .search {
                showingDetail = true
            }
        } label: {
            VStack(spacing: 16) {
                // 航线和价格
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(flight.departure)
                            .font(.title2)
                            .fontWeight(.bold)
                        Text(flight.departureCity)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Image(systemName: "airplane")
                            .foregroundColor(isHighlighted ? .white : .gray)
                        Text(flight.duration)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(flight.arrival)
                            .font(.title2)
                            .fontWeight(.bold)
                        Text(flight.arrivalCity)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                Divider()
                
                // 时间和航空公司信息
                HStack {
                    // 时间信息
                    VStack(alignment: .leading, spacing: 4) {
                        Text(flight.departureTime)
                            .font(.headline)
                        Text("→")
                            .font(.caption)
                        Text(flight.arrivalTime)
                            .font(.headline)
                    }
                    
                    Spacer()
                    
                    // 航空公司和价格
                    VStack(alignment: .trailing, spacing: 4) {
                        HStack {
                            Text(flight.airline)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(isHighlighted ? Color.black.opacity(0.3) : Color.gray.opacity(0.1))
                                .clipShape(Capsule())
                            
                            Text(flight.transfers)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.accentBlue.opacity(0.1))
                                .foregroundColor(.accentBlue)
                                .clipShape(Capsule())
                        }
                        
                        Text(flight.price)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.accentBlue)
                    }
                }
                
                // 座位信息
                HStack {
                    ForEach(SeatClass.allCases, id: \.self) { seatClass in
                        let availability = getSeatAvailability(for: seatClass)
                        VStack(spacing: 2) {
                            Text(seatClass.rawValue)
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(availability)
                                .font(.caption)
                                .foregroundColor(availability == "已满" ? .red : .green)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.top, 8)
                
                // 根据模式显示不同的底部内容
                if mode == .order {
                    HStack {
                        Text("订单状态")
                            .foregroundColor(.gray)
                        Text("已出票")
                            .foregroundColor(.green)
                        Spacer()
                        Button("查看详情") {
                            showingDetail = true
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding(.top, 8)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(isHighlighted ? Color.accentBlue : Color.cardWhite)
            .foregroundColor(isHighlighted ? .white : .black)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showingDetail) {
            FlightDetailView(flight: flight) {
                showingPayment = true
            }
        }
        .sheet(isPresented: $showingPayment) {
            PaymentView(
                flight: flight,
                isRoundTrip: viewModel.isRoundTrip,
                returnFlight: viewModel.returnFlights.first
            )
        }
    }
    
    // 模拟获取座位可用性
    private func getSeatAvailability(for seatClass: SeatClass) -> String {
        switch seatClass {
        case .economy:
            return "12座"
        case .business:
            return "4座"
        case .first:
            return "已满"
        }
    }
} 
