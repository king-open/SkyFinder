import Foundation

struct FlightRoutes {
    // 使用字典存储所有航线，key 是出发地-目的地组合
    static let routeMap: [String: [Flight]] = {
        var map: [String: [Flight]] = [:]
        
        // 添加所有航线组合
        let allRoutes = [
            // 北京出发
            ("PEK", "SHA"): Flight(
                departure: "PEK", arrival: "SHA",
                departureCity: "北京首都", arrivalCity: "上海虹桥",
                departureTime: "07:00 AM", arrivalTime: "09:20 AM",
                duration: "2h20m", transfers: "直飞",
                price: "¥1280", airline: "国航",
                isInternational: false
            ),
            ("PEK", "CAN"): Flight(
                departure: "PEK", arrival: "CAN",
                departureCity: "北京首都", arrivalCity: "广州白云",
                departureTime: "08:00 AM", arrivalTime: "11:15 AM",
                duration: "3h15m", transfers: "直飞",
                price: "¥1580", airline: "南航",
                isInternational: false
            ),
            
            // 上海出发
            ("SHA", "SZX"): Flight(
                departure: "SHA", arrival: "SZX",
                departureCity: "上海虹桥", arrivalCity: "深圳宝安",
                departureTime: "09:30 AM", arrivalTime: "12:00 PM",
                duration: "2h30m", transfers: "直飞",
                price: "¥1380", airline: "东航",
                isInternational: false
            ),
            
            // ... 添加其他航线 ...
        ]
        
        // 将航线添加到字典中
        for (route, flight) in allRoutes {
            let key = "\(route.0)-\(route.1)"
            map[key] = [flight]  // 每个路线可以有多个航班
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
} 
