import SwiftUI

struct NotificationButton: View {
    var body: some View {
        Circle()
            .strokeBorder(.white.opacity(0.2), lineWidth: 1)
            .frame(width: 40, height: 40)
            .overlay {
                ZStack {
                    Image(systemName: "bell")
                        .foregroundColor(.white)
                    
                    // 蓝色小圆点
                    Circle()
                        .fill(Color.accentBlue)
                        .frame(width: 8, height: 8)
                        .offset(x: 8, y: -8)
                }
            }
    }
}

struct ProfileImage: View {
    var body: some View {
        Circle()
            .fill(Color.cardWhite.opacity(0.1))
            .frame(width: 40, height: 40)
            .overlay {
                // 这里需要添加实际的头像图片
                Image("avatar") // 需要在 Assets 中添加头像图片
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
            }
    }
}

struct DateSelectionButton: View {
    let date: Date
    
    var body: some View {
        NavigationLink {
            SeatSelectionView(
                departure: "CDG",
                arrival: "JFK",
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
}

struct ReturnButton: View {
    var body: some View {
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
    }
}

struct FilterButton: View {
    var body: some View {
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
} 
