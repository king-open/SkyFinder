import Foundation

struct FlightRoutes {
    // 使用字符串作为字典的键
    static let routeMap: [String: [Flight]] = {
        var map: [String: [Flight]] = [:]
        
        // 定义所有航线
        let routes: [(from: String, to: String, flight: Flight)] = [
            // 北京出发
            (from: "PEK", to: "SHA", flight: Flight(
                departure: "PEK", arrival: "SHA",
                departureCity: "北京首都", arrivalCity: "上海虹桥",
                departureTime: "07:00 AM", arrivalTime: "09:20 AM",
                duration: "2h20m", transfers: "直飞",
                price: "¥1280", airline: "国航",
                isInternational: false
            )),
            
            (from: "PEK", to: "CAN", flight: Flight(
                departure: "PEK", arrival: "CAN",
                departureCity: "北京首都", arrivalCity: "广州白云",
                departureTime: "08:00 AM", arrivalTime: "11:15 AM",
                duration: "3h15m", transfers: "直飞",
                price: "¥1580", airline: "南航",
                isInternational: false
            )),
            
            // 上海出发
            (from: "SHA", to: "SZX", flight: Flight(
                departure: "SHA", arrival: "SZX",
                departureCity: "上海虹桥", arrivalCity: "深圳宝安",
                departureTime: "09:30 AM", arrivalTime: "12:00 PM",
                duration: "2h30m", transfers: "直飞",
                price: "¥1380", airline: "东航",
                isInternational: false
            ))
            
            // ... 添加其他航线 ...
        ]
        
        // 将航线添加到字典中
        for route in routes {
            let key = "\(route.from)-\(route.to)"
            map[key] = [route.flight]  // 每个路线可以有多个航班
        }
        
        return map
    }()
    
    // 根据出发地和目的地快速查找航班
    static func flights(from departure: String, to arrival: String) -> [Flight] {
        let key = "\(departure)-\(arrival)"
        return routeMap[key] ?? []
    }
    
    // 获取所有航线
    static var allRoutes: [Flight] {
        routeMap.values.flatMap { $0 }
    }
    
    // 添加推荐系统
    static func recommendedFlights(
        for user: User?,
        from departure: String,
        to arrival: String
    ) -> [Flight] {
        var recommendations: [Flight] = []
        
        // 1. 首先尝试直达航班
        let directFlights = flights(from: departure, to: arrival)
        recommendations.append(contentsOf: directFlights)
        
        // 2. 如果没有直达，寻找中转航班
        if directFlights.isEmpty {
            recommendations.append(contentsOf: findTransferFlights(from: departure, to: arrival))
        }
        
        // 3. 如果有用户数据，基于用户偏好排序
        if let user = user {
            recommendations.sort { flight1, flight2 in
                // 根据用户舱位偏好排序
                if flight1.cabinClass == user.preferences.preferredClass {
                    return true
                }
                // 根据用户常用航空公司排序
                if flight1.airline == user.preferredAirline {
                    return true
                }
                // 根据价格区间排序
                return getFlightScore(flight1, for: user) > getFlightScore(flight2, for: user)
            }
        }
        
        // 4. 添加热门替代航线
        if recommendations.isEmpty {
            recommendations.append(contentsOf: getAlternativeRoutes(from: departure, to: arrival))
        }
        
        return recommendations
    }
    
    // 寻找中转航班
    private static func findTransferFlights(from departure: String, to arrival: String) -> [Flight] {
        var transfers: [Flight] = []
        let possibleTransfers = ["PEK", "SHA", "CAN", "CTU"] // 主要枢纽机场
        
        for transfer in possibleTransfers {
            if let firstLeg = flights(from: departure, to: transfer).first,
               let secondLeg = flights(from: transfer, to: arrival).first {
                // 创建一个虚拟的中转航班
                let transferFlight = Flight(
                    departure: departure,
                    arrival: arrival,
                    departureCity: firstLeg.departureCity,
                    arrivalCity: secondLeg.arrivalCity,
                    departureTime: firstLeg.departureTime,
                    arrivalTime: secondLeg.arrivalTime,
                    duration: calculateDuration(firstLeg, secondLeg),
                    transfers: "经停\(getAirportCity(transfer))",
                    price: calculateTotalPrice(firstLeg, secondLeg),
                    airline: firstLeg.airline,
                    isInternational: firstLeg.isInternational || secondLeg.isInternational
                )
                transfers.append(transferFlight)
            }
        }
        
        return transfers
    }
    
    // 获取替代航线
    private static func getAlternativeRoutes(from departure: String, to arrival: String) -> [Flight] {
        // 根据历史数据的热门替代路线
        let alternatives = [
            ("PEK", "SHA"): [("PEK", "HGH"), ("PEK", "NKG")],  // 北京-上海的替代路线
            ("CAN", "PEK"): [("SZX", "PEK"), ("CAN", "PKX")],  // 广州-北京的替代路线
            // ... 添加更多替代路线
        ]
        
        let key = "\(departure)-\(arrival)"
        guard let altRoutes = alternatives[key] else { return [] }
        
        return altRoutes.flatMap { alt in
            flights(from: alt.0, to: alt.1)
        }
    }
    
    // 计算航班得分
    private static func getFlightScore(_ flight: Flight, for user: User) -> Double {
        var score = 0.0
        
        // 价格因素
        let price = Double(flight.price.dropFirst()) ?? 0
        score += 100 - (price / 100) // 价格越低分数越高
        
        // 时间因素
        if isPreferredTime(flight.departureTime) {
            score += 20
        }
        
        // 航空公司因素
        if flight.airline == user.preferredAirline {
            score += 30
        }
        
        // 直飞因素
        if flight.transfers == "直飞" {
            score += 50
        }
        
        return score
    }
    
    // 辅助方法
    private static func calculateDuration(_ first: Flight, _ second: Flight) -> String {
        // 简单实现，实际应该计算真实时间
        return "\(first.duration) + \(second.duration)"
    }
    
    private static func calculateTotalPrice(_ first: Flight, _ second: Flight) -> String {
        let price1 = Double(first.price.dropFirst()) ?? 0
        let price2 = Double(second.price.dropFirst()) ?? 0
        return "¥\(Int(price1 + price2))"
    }
    
    private static func getAirportCity(_ code: String) -> String {
        // 简单实现，实际应该查询机场数据
        let airports = ["PEK": "北京", "SHA": "上海", "CAN": "广州", "CTU": "成都"]
        return airports[code] ?? code
    }
    
    private static func isPreferredTime(_ time: String) -> Bool {
        // 简单实现，假设早上9点到晚上6点是较受欢迎的时间
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        guard let date = formatter.date(from: time) else { return false }
        let hour = Calendar.current.component(.hour, from: date)
        return hour >= 9 && hour <= 18
    }
} 
