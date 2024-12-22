import Foundation

class FlightBookingViewModel: ObservableObject {
    @Published var fromAirport = "PEK"
    @Published var toAirport = "SHA"
    @Published var fromCity = "北京首都"
    @Published var toCity = "上海虹桥"
    @Published var selectedDate = Date()
    @Published var flights: [Flight] = []
    @Published var filter = FlightFilter()
    @Published var isRoundTrip = false
    @Published var returnDate = Date()
    @Published var returnFlights: [Flight] = []
    
    // 将 commonAirports 改为公开属性
    let commonAirports: [Airport] = [
        // 国内机场
        Airport(code: "PEK", city: "北京首都"),
        Airport(code: "PKX", city: "北京大兴"),
        Airport(code: "SHA", city: "上海虹桥"),
        Airport(code: "PVG", city: "上海浦东"),
        Airport(code: "CAN", city: "广州白云"),
        Airport(code: "SZX", city: "深圳宝安"),
        Airport(code: "CTU", city: "成都双流"),
        Airport(code: "CKG", city: "重庆江北"),
        Airport(code: "HKG", city: "香港国际"),
        Airport(code: "TPE", city: "台北桃园"),
        // 国际机场
        Airport(code: "NRT", city: "东京成田"),
        Airport(code: "ICN", city: "首尔仁川")
    ]
    
    // 所有可能的航班数据
    private let allFlights: [Flight] = [
        // 北京 -> 上海航线
        Flight(
            departure: "PEK", arrival: "SHA",
            departureCity: "北京首都", arrivalCity: "上海虹桥",
            departureTime: "07:00 AM", arrivalTime: "09:20 AM",
            duration: "2h20m", transfers: "直飞",
            price: "¥1280", airline: "国航",
            isInternational: false
        ),
        Flight(
            departure: "PEK", arrival: "SHA",
            departureCity: "北京首都", arrivalCity: "上海虹桥",
            departureTime: "09:30 AM", arrivalTime: "11:50 AM",
            duration: "2h20m", transfers: "直飞",
            price: "¥1380", airline: "东航",
            isInternational: false
        ),
        Flight(
            departure: "PEK", arrival: "SHA",
            departureCity: "北京首都", arrivalCity: "上海虹桥",
            departureTime: "13:00 PM", arrivalTime: "15:20 PM",
            duration: "2h20m", transfers: "直飞",
            price: "¥1180", airline: "南航",
            isInternational: false
        ),
        
        // 北京 -> 广州航线
        Flight(
            departure: "PEK", arrival: "CAN",
            departureCity: "北京首都", arrivalCity: "广州白云",
            departureTime: "08:00 AM", arrivalTime: "11:15 AM",
            duration: "3h15m", transfers: "直飞",
            price: "¥1580", airline: "南航",
            isInternational: false
        ),
        Flight(
            departure: "PEK", arrival: "CAN",
            departureCity: "北京首都", arrivalCity: "广州白云",
            departureTime: "14:30 PM", arrivalTime: "17:45 PM",
            duration: "3h15m", transfers: "直飞",
            price: "¥1680", airline: "国航",
            isInternational: false
        ),
        
        // ... 其他航线保持不变 ...
    ]
    
    init() {
        updateFlights()
    }
    
    func updateFlights() {
        // 更新去程航班
        flights = allFlights
            .filter { flight in
                flight.departure == fromAirport && flight.arrival == toAirport
            }
            .sorted { flight1, flight2 in
                let formatter = DateFormatter()
                formatter.dateFormat = "hh:mm a"
                let time1 = formatter.date(from: flight1.departureTime) ?? Date()
                let time2 = formatter.date(from: flight2.departureTime) ?? Date()
                return time1 < time2
            }
        
        // 如果是往返，更新返程航班
        if isRoundTrip {
            returnFlights = allFlights
                .filter { flight in
                    flight.departure == toAirport && flight.arrival == fromAirport
                }
                .sorted { flight1, flight2 in
                    let formatter = DateFormatter()
                    formatter.dateFormat = "hh:mm a"
                    let time1 = formatter.date(from: flight1.departureTime) ?? Date()
                    let time2 = formatter.date(from: flight2.departureTime) ?? Date()
                    return time1 < time2
                }
        } else {
            returnFlights = []
        }
    }
    
    func swapAirports() {
        let tempAirport = fromAirport
        let tempCity = fromCity
        
        fromAirport = toAirport
        fromCity = toCity
        
        toAirport = tempAirport
        toCity = tempCity
        
        // 交换后更新航班列表
        updateFlights()
    }
    
    var filteredFlights: [Flight] {
        flights.filter { flight in
            // 价格筛选
            let price = Double(flight.price.dropFirst()) ?? 0
            guard filter.priceRange.contains(price) else { return false }
            
            // 航空公司筛选
            if !filter.airlines.isEmpty && !filter.airlines.contains(flight.airline) {
                return false
            }
            
            // 直飞筛选
            if filter.directFlightsOnly && flight.transfers != "直飞" {
                return false
            }
            
            return true
        }
    }
    
    var totalPrice: String {
        let outboundPrice = Double(flights.first?.price.dropFirst() ?? "0") ?? 0
        let returnPrice = isRoundTrip ? (Double(returnFlights.first?.price.dropFirst() ?? "0") ?? 0) : 0
        return "¥\(Int(outboundPrice + returnPrice))"
    }
    
    // 取消返程
    func cancelReturnFlight() {
        isRoundTrip = false
        returnFlights = []
        // 可以在这里添加其他清理逻辑
    }
}

// 机场数据模型
struct Airport: Identifiable {
    let id = UUID()
    let code: String
    let city: String
} 
