import SwiftUI

struct BoardingPassView: View {
    let flightNumber: String
    let departure: String
    let arrival: String
    let departureCity: String
    let arrivalCity: String
    let boardingTime: String
    let departureTime: String
    let arrivalTime: String
    let date: String
    let flightClass: String
    let passengerName: String
    let terminal: String
    let gate: String
    let seat: String
    let airline: String
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 登机牌内容
                VStack(alignment: .leading, spacing: 24) {
                    // 航班号和航空公司
                    HStack {
                        Text(flightNumber)
                            .foregroundColor(.gray)
                        Spacer()
                        Text("AIRBUS")
                            .fontWeight(.medium)
                    }
                    
                    // 出发地和目的地
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(departure)
                                .font(.system(size: 44, weight: .bold))
                            Text(departureCity)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "airplane")
                            .font(.title2)
                            .padding(.top, 8)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text(arrival)
                                .font(.system(size: 44, weight: .bold))
                            Text(arrivalCity)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // 时间信息
                    HStack {
                        TimeInfoView(title: "登机时间", time: boardingTime)
                        Spacer()
                        TimeInfoView(title: "起飞", time: departureTime)
                        Spacer()
                        TimeInfoView(title: "到达", time: arrivalTime)
                    }
                    
                    // 日期和舱位
                    HStack {
                        DateClassView(title: "日期", info: date)
                        Spacer()
                        DateClassView(title: "舱位", info: flightClass)
                    }
                    
                    // 乘客姓名
                    VStack(alignment: .leading, spacing: 4) {
                        Text("乘客")
                            .foregroundColor(.gray)
                        Text(passengerName)
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
                    
                    // 条形码
                    Image("barcode") // 需要添加条形码图片资源
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 80)
                    
                    // 登机信息
                    HStack {
                        GateInfoView(title: "航站楼", info: terminal)
                        Spacer()
                        GateInfoView(title: "登机口", info: gate)
                        Spacer()
                        GateInfoView(title: "座位", info: seat)
                    }
                }
                .padding(24)
                .background(.white)
                .foregroundColor(.black)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .padding()
            }
            .background(Color(red: 0.06, green: 0.06, blue: 0.06))
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

struct TimeInfoView: View {
    let title: String
    let time: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .foregroundColor(.gray)
                .font(.caption)
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

#Preview {
    BoardingPassView(
        flightNumber: "AB 4723211",
        departure: "CDG",
        arrival: "JFK",
        departureCity: "巴黎, 法国",
        arrivalCity: "纽约, 美国",
        boardingTime: "02:20 AM",
        departureTime: "03:00 AM",
        arrivalTime: "09:00 AM",
        date: "3月12日, 周二",
        flightClass: "经济舱",
        passengerName: "张三",
        terminal: "1",
        gate: "37",
        seat: "1C",
        airline: "AIRBUS"
    )
} 
