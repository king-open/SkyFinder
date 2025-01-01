import SwiftUI
import Foundation

struct FlightDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let flight: Flight
    let onBooking: () -> Void
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // 航班基本信息
                    FlightBasicInfo(flight: flight)
                    
                    // 价格日历
                    PriceCalendarView(selectedDate: .constant(Date()))
                    
                    // 舱位选择
                    CabinSelectionView()
                    
                    // 航班详细信息
                    FlightDetailInfo(flight: flight)
                }
                .padding()
            }
            .navigationTitle("航班详情")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("关闭") {
                        dismiss()
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                Button {
                    dismiss()
                    onBooking()
                } label: {
                    Text("预订 \(flight.price)")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentBlue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding()
            }
        }
    }
}

// 航班基本信息组件
struct FlightBasicInfo: View {
    let flight: Flight
    
    var body: some View {
        VStack(spacing: 20) {
            // 航线信息
            HStack {
                VStack(alignment: .leading) {
                    Text(flight.departure)
                        .font(.system(size: 44, weight: .bold))
                    Text(flight.departureCity)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                VStack(spacing: 4) {
                    Image(systemName: "airplane")
                    Text(flight.duration)
                        .font(.caption)
                }
                .foregroundColor(.gray)
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(flight.arrival)
                        .font(.system(size: 44, weight: .bold))
                    Text(flight.arrivalCity)
                        .foregroundColor(.gray)
                }
            }
            
            // 时间信息
            HStack {
                VStack(alignment: .leading) {
                    Text("出发")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(flight.departureTime)
                        .font(.title3)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("到达")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(flight.arrivalTime)
                        .font(.title3)
                }
            }
        }
        .padding()
        .background(Color.cardWhite)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// 价格日历组件
struct PriceCalendarView: View {
    @Binding var selectedDate: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("价格日历")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(0..<7) { index in
                        let date = Calendar.current.date(byAdding: .day, value: index, to: Date())!
                        DayPriceCard(
                            date: date,
                            price: getPrice(for: date),
                            isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate)
                        )
                        .onTapGesture {
                            selectedDate = date
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.cardWhite)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func getPrice(for date: Date) -> Int {
        // 模拟不同日期的价格
        let weekday = Calendar.current.component(.weekday, from: date)
        return weekday == 1 || weekday == 7 ? 1580 : 1280
    }
}

// 单日价格卡片
struct DayPriceCard: View {
    let date: Date
    let price: Int
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            Text(date.formatted(.dateTime.weekday(.abbreviated)))
                .font(.caption)
            Text(date.formatted(.dateTime.day()))
                .font(.headline)
            Text("¥\(price)")
                .font(.caption)
                .foregroundColor(.accentBlue)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(isSelected ? Color.accentBlue.opacity(0.1) : Color.clear)
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(isSelected ? Color.accentBlue : Color.clear)
        }
    }
}

// 舱位选择组件
struct CabinSelectionView: View {
    @State private var selectedCabin: SeatClass = .economy
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("舱位选择")
                .font(.headline)
            
            ForEach(SeatClass.allCases, id: \.self) { cabin in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(cabin.rawValue)
                            .font(.headline)
                        Text(getCabinFeatures(for: cabin))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Text("¥\(getCabinPrice(for: cabin))")
                        .font(.headline)
                        .foregroundColor(.accentBlue)
                }
                .padding()
                .background(selectedCabin == cabin ? Color.accentBlue.opacity(0.1) : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(selectedCabin == cabin ? Color.accentBlue : Color.clear)
                }
                .onTapGesture {
                    selectedCabin = cabin
                }
            }
        }
        .padding()
        .background(Color.cardWhite)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func getCabinFeatures(for cabin: SeatClass) -> String {
        switch cabin {
        case .economy:
            return "标准座位 | 免费小食"
        case .business:
            return "宽敞座位 | 优质餐饮 | 快速登机"
        case .first:
            return "豪华套间 | 专属服务 | VIP通道"
        }
    }
    
    private func getCabinPrice(for cabin: SeatClass) -> Int {
        switch cabin {
        case .economy: return 1280
        case .business: return 3880
        case .first: return 6880
        }
    }
}

// 航班详细信息组件
struct FlightDetailInfo: View {
    let flight: Flight
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("航班详情")
                .font(.headline)
            
            VStack(spacing: 16) {
                DetailRow(title: "航班号", value: flight.id.uuidString)
                DetailRow(title: "机型", value: "波音737-800")
                DetailRow(title: "餐食", value: "提供")
                DetailRow(title: "准点率", value: "95%")
                DetailRow(title: "行李额", value: "20kg")
            }
        }
        .padding()
        .background(Color.cardWhite)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
        }
    }
} 
