import SwiftUI

struct FlightBookingView: View {
    @StateObject private var viewModel = FlightBookingViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                // 顶部区域
                HeaderView()
                
                // 机场选择区域
                VStack(spacing: 0) {
                    AirportSelectionView(
                        label: "出发地",
                        code: viewModel.fromAirport,
                        city: viewModel.fromCity
                    )
                    AirportSelectionView(
                        label: "目的地",
                        code: viewModel.toAirport,
                        city: viewModel.toCity
                    )
                }
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
        .preferredColorScheme(.dark)
    }
}

// 拆分成子视图
struct HeaderView: View {
    var body: some View {
        HStack {
            Text("预订您的\n下一趟航班")
                .font(.title)
                .fontWeight(.bold)
            
            Spacer()
            
            NotificationAndProfileView()
        }
    }
}

struct NotificationAndProfileView: View {
    var body: some View {
        HStack(spacing: 12) {
            NotificationButton()
            ProfileImage()
        }
    }
}

struct ActionButtonsView: View {
    @Binding var date: Date
    
    var body: some View {
        HStack(spacing: 12) {
            DateSelectionButton(date: date)
            ReturnButton()
            FilterButton()
        }
    }
}

// 修改 FlightResultCard
struct FlightResultCard: View {
    let flight: Flight
    @State private var isHighlighted = false
    
    var body: some View {
        NavigationLink {
            BoardingPassView(flight: flight)
        } label: {
            // ... 卡片内容 ...
        }
    }
} 
