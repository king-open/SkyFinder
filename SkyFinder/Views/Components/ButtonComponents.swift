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
                // 使用系统图标替代
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .foregroundColor(.gray)
                    .padding(8)
            }
    }
}

struct DateSelectionButton: View {
    @State private var showingDatePicker = false
    @Binding var date: Date
    
    var body: some View {
        Button {
            showingDatePicker.toggle()
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("出发")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                    Text(date.formatted(.custom))
                        .foregroundColor(.white)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.accentBlue)
            .clipShape(Capsule())
        }
        .sheet(isPresented: $showingDatePicker) {
            DateSelectionView(selectedDate: $date)
        }
    }
}

// 添加日期格式化扩展
extension FormatStyle where Self == Date.FormatStyle {
    static var custom: Self {
        .init()
            .year(.twoDigits)
            .month(.defaultDigits)
            .day(.defaultDigits)
            .weekday(.abbreviated)
            .locale(.init(identifier: "zh_CN"))
    }
}

struct ReturnButton: View {
    @Binding var isRoundTrip: Bool
    @Binding var returnDate: Date
    @State private var showingDatePicker = false
    
    var body: some View {
        Button {
            if isRoundTrip {
                showingDatePicker = true
            } else {
                isRoundTrip = true
                showingDatePicker = true
            }
        } label: {
            HStack {
                if isRoundTrip {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("返程")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                        Text(returnDate.formatted(.custom))
                            .foregroundColor(.white)
                    }
                } else {
                    Image(systemName: "plus")
                        .foregroundColor(Color.accentBlue)
                    Text("返程")
                        .foregroundColor(.white)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(isRoundTrip ? Color.accentBlue : .clear)
            .overlay {
                if !isRoundTrip {
                    Capsule()
                        .strokeBorder(Color.accentBlue.opacity(0.5), 
                                    style: StrokeStyle(lineWidth: 1, dash: [4]))
                }
            }
            .clipShape(Capsule())
        }
        .sheet(isPresented: $showingDatePicker) {
            DateSelectionView(selectedDate: $returnDate)
        }
    }
}

struct FilterButton: View {
    @Binding var filter: FlightFilter
    @State private var showingFilter = false
    
    var body: some View {
        Button {
            showingFilter = true
        } label: {
            Image(systemName: "slider.horizontal.3")
                .padding()
                .background(Color.accentBlue)
                .foregroundColor(.white)
                .clipShape(Circle())
        }
        .sheet(isPresented: $showingFilter) {
            FlightFilterView(filter: $filter)
        }
    }
} 
