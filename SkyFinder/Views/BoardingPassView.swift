import SwiftUI

struct BoardingPassView: View {
    let flight: Flight
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 登机牌内容
                VStack(alignment: .leading, spacing: 24) {
                    // 航班号和航空公司
                    HStack {
                        Text(flight.id.uuidString)
                            .foregroundColor(.gray)
                        Spacer()
                        Text(flight.airline)
                            .fontWeight(.medium)
                    }
                    
                    // 出发地和目的地
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(flight.departure)
                                .font(.system(size: 44, weight: .bold))
                            Text(flight.departureCity)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "airplane")
                            .font(.title2)
                            .padding(.top, 8)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text(flight.arrival)
                                .font(.system(size: 44, weight: .bold))
                            Text(flight.arrivalCity)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // 时间信息
                    HStack {
                        TimeInfoView(title: "登机时间", time: "02:20 AM")
                        Spacer()
                        TimeInfoView(title: "起飞", time: flight.departureTime)
                        Spacer()
                        TimeInfoView(title: "到达", time: flight.arrivalTime)
                    }
                    
                    // 日期和舱位
                    HStack {
                        DateClassView(title: "日期", info: "3月12日, 周二")
                        Spacer()
                        DateClassView(title: "舱位", info: "经济舱")
                    }
                    
                    // 乘客姓名
                    VStack(alignment: .leading, spacing: 4) {
                        Text("乘客")
                            .foregroundColor(.gray)
                        Text("张三")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    
                    // 虚线
                    HStack {
                        ForEach(0..<30) { _ in
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 4, height: 4)
                            Spacer()
                        }
                    }
                    .padding(.vertical)
                    
                    // 登机信息
                    HStack {
                        GateInfoView(title: "航站楼", info: "1")
                        Spacer()
                        GateInfoView(title: "登机口", info: "37")
                        Spacer()
                        GateInfoView(title: "座位", info: "1C")
                    }
                }
                .padding(24)
                .background(.white)
                .foregroundColor(.black)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .padding()
            }
            .background(Color.backgroundBlue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("登机牌")
                        .font(.headline)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 20) {
                        Button(action: {}) {
                            Image(systemName: "square.and.arrow.up")
                        }
                        Button(action: {}) {
                            Image(systemName: "ellipsis")
                        }
                    }
                }
            }
        }
    }
}

// 辅助视图组件
struct TimeInfoView: View {
    let title: String
    let time: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .foregroundColor(.gray)
            Text(time)
                .fontWeight(.medium)
        }
    }
}

struct DateClassView: View {
    let title: String
    let info: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .foregroundColor(.gray)
            Text(info)
                .fontWeight(.medium)
        }
    }
}

struct GateInfoView: View {
    let title: String
    let info: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .foregroundColor(.gray)
            Text(info)
                .font(.title)
                .fontWeight(.bold)
        }
    }
} 
