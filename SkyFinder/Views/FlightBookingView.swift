import SwiftUI

struct FlightBookingView: View {
    @StateObject private var viewModel = FlightBookingViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                // 顶部区域
                HeaderView()
                
                // 机场选择区域
                VStack(spacing: 1) {
                    AirportSelectionView(
                        label: "出发地",
                        code: viewModel.fromAirport,
                        city: viewModel.fromCity
                    ) { code, city in
                        viewModel.fromAirport = code
                        viewModel.fromCity = city
                        viewModel.updateFlights()
                    }
                    
                    Divider()
                        .padding(.horizontal)
                        .background(Color.gray.opacity(0.1))
                    
                    AirportSelectionView(
                        label: "目的地",
                        code: viewModel.toAirport,
                        city: viewModel.toCity
                    ) { code, city in
                        viewModel.toAirport = code
                        viewModel.toCity = city
                        viewModel.updateFlights()
                    }
                }
                .padding(.vertical, 8)
                .background(Color.cardWhite)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .onTapGesture {
                    viewModel.swapAirports()
                }
                
                // 日期选择和筛选
                ActionButtonsView(date: $viewModel.selectedDate)
                
                // 结果列表
                Text("搜索结果")
                    .font(.title2)
                    .fontWeight(.bold)
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.flights) { flight in
                            FlightResultCard(flight: flight)
                        }
                    }
                }
            }
            .padding()
            .background(Color.backgroundBlue)
        }
        .environmentObject(viewModel)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    FlightBookingView()
}
