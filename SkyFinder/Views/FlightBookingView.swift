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
                HStack(spacing: 12) {
                    ForEach(userViewModel.frequentRoutes.prefix(3)) { route in
                        FrequentRouteCard(route: route)
                            .onTapGesture {
                                viewModel.fromAirport = route.from
                                viewModel.fromCity = route.fromCity
                                viewModel.toAirport = route.to
                                viewModel.toCity = route.toCity
                                viewModel.updateFlights()
                            }
                    }
                }
                .padding(.horizontal)
                
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
                ActionButtonsView(
                    date: $viewModel.selectedDate,
                    isRoundTrip: $viewModel.isRoundTrip,
                    returnDate: $viewModel.returnDate,
                    filter: $viewModel.filter
                )
                
                // 结果列表
                VStack(spacing: 16) {
                    if viewModel.isRoundTrip {
                        // 去程航班
                        VStack(alignment: .leading, spacing: 12) {
                            Text("去程")
                                .font(.headline)
                                .foregroundColor(.gray)
                            
                            ForEach(viewModel.flights) { flight in
                                FlightResultCard(flight: flight)
                            }
                        }
                        
                        // 返程航班
                        VStack(alignment: .leading, spacing: 12) {
                            Text("返程")
                                .font(.headline)
                                .foregroundColor(.gray)
                            
                            ForEach(viewModel.returnFlights) { flight in
                                FlightResultCard(flight: flight)
                            }
                        }
                        
                        // 总价
                        HStack {
                            Text("总价")
                                .font(.headline)
                            Spacer()
                            Text(viewModel.totalPrice)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.accentBlue)
                        }
                        .padding()
                        .background(Color.cardWhite)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    } else {
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

#Preview {
    FlightBookingView()
}
