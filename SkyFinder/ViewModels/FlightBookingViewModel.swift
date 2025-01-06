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
    @Published var page = 1
    @Published var isLoading = false
    
    // 将 commonAirports 改为公开属性
    let commonAirports: [Airport] = [
        // 华北地区
        Airport(code: "PEK", city: "北京首都"),
        Airport(code: "PKX", city: "北京大兴"),
        Airport(code: "TSN", city: "天津滨海"),
        Airport(code: "TYN", city: "太原武宿"),
        Airport(code: "SJW", city: "石家庄正定"),
        
        // 华东地区
        Airport(code: "SHA", city: "上海虹桥"),
        Airport(code: "PVG", city: "上海浦东"),
        Airport(code: "NKG", city: "南京禄口"),
        Airport(code: "HGH", city: "杭州萧山"),
        Airport(code: "TAO", city: "青岛流亭"),
        Airport(code: "XMN", city: "厦门高崎"),
        Airport(code: "FOC", city: "福州长乐"),
        
        // 华南地区
        Airport(code: "CAN", city: "广州白云"),
        Airport(code: "SZX", city: "深圳宝安"),
        Airport(code: "HAK", city: "海口美兰"),
        Airport(code: "SYX", city: "三亚凤凰"),
        
        // 华中地区
        Airport(code: "WUH", city: "武汉天河"),
        Airport(code: "CSX", city: "长沙黄花"),
        Airport(code: "CGO", city: "郑州新郑"),
        
        // 西南地区
        Airport(code: "CTU", city: "成都双流"),
        Airport(code: "CKG", city: "重庆江北"),
        Airport(code: "KMG", city: "昆明长水"),
        Airport(code: "TNA", city: "济南遥墙"),
        
        // 西北地区
        Airport(code: "XIY", city: "西安咸阳"),
        Airport(code: "LHW", city: "兰州中川"),
        Airport(code: "URC", city: "乌鲁木齐地窝堡"),
        
        // 东北地区
        Airport(code: "SHE", city: "沈阳桃仙"),
        Airport(code: "DLC", city: "大连周水子"),
        Airport(code: "HRB", city: "哈尔滨太平"),
        Airport(code: "CGQ", city: "长春龙嘉"),
        
        // 港澳台地区
        Airport(code: "HKG", city: "香港国际"),
        Airport(code: "MFM", city: "澳门国际"),
        Airport(code: "TPE", city: "台北桃园")
    ]
    
    // 使用 FlightRoutes 替换原来的 allFlights
    private let allFlights: [Flight] = FlightRoutes.allRoutes
    
    // 添加缓存
    private var airportSearchCache: [String: [Airport]] = [:]
    
    init() {
        updateFlights()
    }
    
    func updateFlights() {
        // 使用推荐系统查找航班
        flights = FlightRoutes.recommendedFlights(
            for: userViewModel.currentUser,
            from: fromAirport,
            to: toAirport
        ).sorted { flight1, flight2 in
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"
            let time1 = formatter.date(from: flight1.departureTime) ?? Date()
            let time2 = formatter.date(from: flight2.departureTime) ?? Date()
            return time1 < time2
        }
        
        // 往返逻辑类似
        if isRoundTrip {
            returnFlights = FlightRoutes.recommendedFlights(
                for: userViewModel.currentUser,
                from: toAirport,
                to: fromAirport
            ).sorted { flight1, flight2 in
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
    
    // 刷新航班列表
    func refreshFlights() async {
        await MainActor.run {
            page = 1
            flights = []
            updateFlights()
        }
    }
    
    // 加载更多航班
    func loadMoreFlights() async {
        guard !isLoading else { return }
        
        await MainActor.run {
            isLoading = true
            page += 1
            
            // 模拟加载更多数据
            let moreFlights = allFlights
                .filter { flight in
                    flight.departure == fromAirport && flight.arrival == toAirport
                }
                .map { flight in
                    // 创建新的航班实例，修改一些属性以模拟不同航班
                    Flight(
                        departure: flight.departure,
                        arrival: flight.arrival,
                        departureCity: flight.departureCity,
                        arrivalCity: flight.arrivalCity,
                        departureTime: modifyTime(flight.departureTime, offset: page * 2),
                        arrivalTime: modifyTime(flight.arrivalTime, offset: page * 2),
                        duration: flight.duration,
                        transfers: flight.transfers,
                        price: "¥\(Int(Double(flight.price.dropFirst())!) + page * 100)",
                        airline: flight.airline,
                        isInternational: flight.isInternational
                    )
                }
            
            flights.append(contentsOf: moreFlights)
            isLoading = false
        }
    }
    
    // 辅助方法：修改时间
    private func modifyTime(_ time: String, offset: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        
        guard let date = formatter.date(from: time) else { return time }
        let modifiedDate = Calendar.current.date(byAdding: .hour, value: offset, to: date) ?? date
        
        return formatter.string(from: modifiedDate)
    }
    
    // 优化搜索建议
    func searchAirports(_ query: String) -> [Airport] {
        // 如果查询为空，返回空数组
        if query.isEmpty {
            return []
        }
        
        // 检查缓存
        if let cached = airportSearchCache[query] {
            return cached
        }
        
        // 转换为小写以进行不区分大小写的搜索
        let lowercaseQuery = query.lowercased()
        
        // 使用 filter 而不是 contains 来提高性能
        let results = commonAirports.filter { airport in
            airport.code.lowercased().hasPrefix(lowercaseQuery) ||
            airport.city.lowercased().contains(lowercaseQuery)
        }
        
        // 缓存结果
        airportSearchCache[query] = results
        
        return results
    }
    
    // 清除缓存
    func clearSearchCache() {
        airportSearchCache.removeAll()
    }
}

// 机场数据模型
struct Airport: Identifiable {
    let id = UUID()
    let code: String
    let city: String
} 
