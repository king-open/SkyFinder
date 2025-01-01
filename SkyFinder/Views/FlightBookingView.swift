import SwiftUI

struct FlightBookingView: View {
    @StateObject private var viewModel = FlightBookingViewModel()
    @StateObject private var userViewModel = UserViewModel()
    @State private var isRefreshing = false
    @State private var hasMoreData = true
    
    var body: some View {
        NavigationStack {
            ScrollView {
                RefreshControl(isRefreshing: $isRefreshing) {
                    // 下拉刷新
                    await viewModel.refreshFlights()
                }
                
                VStack(alignment: .leading, spacing: 24) {
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
                    LazyVStack(spacing: 16) {
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
                            
                            if hasMoreData {
                                ProgressView()
                                    .onAppear {
                                        Task {
                                            await viewModel.loadMoreFlights()
                                        }
                                    }
                            }
                        }
                    }
                }
                .padding()
            }
            .background(Color.backgroundBlue)
        }
        .environmentObject(viewModel)
        .environmentObject(userViewModel)
        .preferredColorScheme(.dark)
    }
}

// 下拉刷新控件
struct RefreshControl: View {
    @Binding var isRefreshing: Bool
    let action: () async -> Void
    
    var body: some View {
        GeometryReader { geometry in
            if geometry.frame(in: .global).minY > 50 {
                Spacer()
                    .onAppear {
                        guard !isRefreshing else { return }
                        isRefreshing = true
                        Task {
                            await action()
                            isRefreshing = false
                        }
                    }
            }
            
            HStack {
                Spacer()
                if isRefreshing {
                    ProgressView()
                }
                Spacer()
            }
        }
        .frame(height: 50)
    }
}

#Preview {
    FlightBookingView()
}
