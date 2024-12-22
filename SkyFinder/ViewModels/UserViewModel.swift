import Foundation

class UserViewModel: ObservableObject {
    @Published var currentUser: User
    
    init() {
        // 模拟用户数据
        self.currentUser = User(
            id: "U123456",
            name: "张三",
            avatar: "avatar_default",
            frequentFlyer: true,
            preferences: User.Preferences(
                preferredClass: .economy,
                mealPreference: .regular,
                seatPreference: .window
            )
        )
    }
    
    // 获取用户常用航线
    var frequentRoutes: [FrequentRoute] {
        [
            FrequentRoute(id: UUID(), from: "PEK", to: "SHA", fromCity: "北京", toCity: "上海"),
            FrequentRoute(id: UUID(), from: "PEK", to: "CAN", fromCity: "北京", toCity: "广州"),
            FrequentRoute(id: UUID(), from: "PEK", to: "CTU", fromCity: "北京", toCity: "成都")
        ]
    }
    
    // 获取用户历史订单
    var recentBookings: [Flight] {
        [
            Flight(
                departure: "PEK",
                arrival: "SHA",
                departureCity: "北京首都",
                arrivalCity: "上海虹桥",
                departureTime: "07:00 AM",
                arrivalTime: "09:20 AM",
                duration: "2h20m",
                transfers: "直飞",
                price: "¥1280",
                airline: "国航",
                isInternational: false
            ),
            Flight(
                departure: "SHA",
                arrival: "PEK",
                departureCity: "上海虹桥",
                arrivalCity: "北京首都",
                departureTime: "10:00 AM",
                arrivalTime: "12:20 PM",
                duration: "2h20m",
                transfers: "直飞",
                price: "¥1380",
                airline: "东航",
                isInternational: false
            )
        ]
    }
    
    // 获取用户积分信息
    var frequentFlyerPoints: Int {
        12500
    }
    
    // 获取用户优惠券
    var availableCoupons: [Coupon] {
        [
            Coupon(id: "C001", discount: 100, minAmount: 1000, expireDate: Date().addingTimeInterval(7*24*60*60)),
            Coupon(id: "C002", discount: 200, minAmount: 2000, expireDate: Date().addingTimeInterval(30*24*60*60))
        ]
    }
}

// 优惠券模型
struct Coupon: Identifiable {
    let id: String
    let discount: Int
    let minAmount: Int
    let expireDate: Date
    
    var isValid: Bool {
        expireDate > Date()
    }
}

struct FrequentRoute: Identifiable {
    let id: UUID
    let from: String
    let to: String
    let fromCity: String
    let toCity: String
} 
