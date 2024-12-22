import SwiftUI

struct FlightBookingView: View {
    @StateObject private var viewModel = FlightBookingViewModel()
    @StateObject private var userViewModel = UserViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                // 顶部区域
                HStack {
                    VStack(alignment: .leading) {
                        Text("您好，\(userViewModel.currentUser.name)")
                            .font(.headline)
                        if userViewModel.currentUser.frequentFlyer {
                            Text("常旅客会员")
                                .font(.subheadline)
                                .foregroundColor(.accentBlue)
                        }
                    }
                    
                    Spacer()
                    
                    NotificationAndProfileView()
                }
                
                // 常用航线
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(userViewModel.frequentRoutes) { route in
                            FrequentRouteCard(route: route)
                                .onTapGesture {
                                    // 点击时更新出发地和目的地
                                    viewModel.fromAirport = route.from
                                    viewModel.fromCity = route.fromCity
                                    viewModel.toAirport = route.to
                                    viewModel.toCity = route.toCity
                                    viewModel.updateFlights()
                                }
                        }
                    }
                    .padding(.horizontal)
                }
                
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
        .environmentObject(userViewModel)
        .preferredColorScheme(.dark)
    }
}

// 常用航线卡片
struct FrequentRouteCard: View {
    let route: Route
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(route.from)
                    .font(.headline)
                Image(systemName: "arrow.right")
                    .font(.caption)
                Text(route.to)
                    .font(.headline)
            }
            
            Text("常用航线")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.cardWhite)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    FlightBookingView()
}
