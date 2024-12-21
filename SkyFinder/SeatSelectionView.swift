import SwiftUI

struct SeatSelectionView: View {
    let backgroundColor = Color(hex: "021324")
    let selectedColor = Color(hex: "3371f5")
    let occupiedColor = Color(hex: "b9cbe3")
    let availableColor = Color(hex: "eff0f3")
    
    @State private var selectedSeat: String?
    let rows = 1...5
    let columns = ["A", "B", "C", "D", "E"]
    
    // 模拟已占用的座位
    let occupiedSeats = ["B2", "B3", "A5", "B5", "C5", "D2", "E2"]
    
    let departure: String
    let arrival: String
    let departureTime: String
    let arrivalTime: String
    let price: String
    let airline: String
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // 选座区域
                VStack(alignment: .leading, spacing: 20) {
                    // 标题和舱位选择
                    HStack {
                        Text("选择座位")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        HStack(spacing: 8) {
                            Menu {
                                Button("经济舱", action: {})
                                Button("商务舱", action: {})
                                Button("头等舱", action: {})
                            } label: {
                                HStack {
                                    Text("舱位")
                                        .foregroundColor(.gray)
                                    Text("经济舱")
                                        .foregroundColor(.black)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background {
                                    Capsule()
                                        .strokeBorder(.gray.opacity(0.3))
                                }
                            }
                            
                            Button(action: {}) {
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.black)
                                    .padding(8)
                                    .background(availableColor)
                                    .clipShape(Circle())
                            }
                        }
                    }
                    
                    // 座位图例
                    HStack(spacing: 24) {
                        LegendItem(color: selectedColor, text: "已选")
                        LegendItem(color: occupiedColor, text: "已占")
                        LegendItem(color: availableColor, text: "可选")
                    }
                    
                    // 座位网格
                    VStack(spacing: 20) {
                        // 列标签
                        HStack {
                            ForEach(columns, id: \.self) { column in
                                Text(column)
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        
                        // 座位
                        ForEach(rows, id: \.self) { row in
                            HStack(spacing: 16) {
                                ForEach(columns, id: \.self) { column in
                                    let seatId = "\(column)\(row)"
                                    SeatView(
                                        seatId: seatId,
                                        isSelected: selectedSeat == seatId,
                                        isOccupied: occupiedSeats.contains(seatId),
                                        selectedColor: selectedColor,
                                        occupiedColor: occupiedColor,
                                        availableColor: availableColor
                                    ) {
                                        selectedSeat = seatId
                                    }
                                    
                                    if column == "C" {
                                        Text("\(row)")
                                            .foregroundColor(.gray)
                                            .frame(width: 20)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(24)
                .background(availableColor)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                
                // 底部信息
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Seat")
                                .foregroundColor(.gray)
                            Text(selectedSeat ?? "-")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("价格")
                                .foregroundColor(.gray)
                            Text(price)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("Class")
                                .foregroundColor(.gray)
                            Text("Economy")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(20)
                    .background(availableColor)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    Button {
                        // 预订动作
                    } label: {
                        Text("立即预订")
                            .font(.title3)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(selectedColor)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                }
            }
            .padding()
            .background(backgroundColor)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("机票详情")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}

struct LegendItem: View {
    let color: Color
    let text: String
    
    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 24, height: 24)
            Text(text)
                .foregroundColor(.gray)
        }
    }
}

struct SeatView: View {
    let seatId: String
    let isSelected: Bool
    let isOccupied: Bool
    let selectedColor: Color
    let occupiedColor: Color
    let availableColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            if !isOccupied {
                action()
            }
        }) {
            ZStack {
                Circle()
                    .fill(isSelected ? selectedColor : (isOccupied ? occupiedColor : availableColor))
                    .frame(width: 40, height: 40)
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                }
            }
        }
        .disabled(isOccupied)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    SeatSelectionView(
        departure: "CDG",
        arrival: "DUB",
        departureTime: "01:20 AM",
        arrivalTime: "05:20 AM",
        price: "$120.00",
        airline: "Air France"
    )
} 
