import Foundation

// 舱位类型
enum SeatClass: String, CaseIterable {
    case economy = "经济舱"
    case business = "商务舱"
    case first = "头等舱"
}

// 乘客信息
struct Passenger: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var idType: IDType
    var idNumber: String
    var phoneNumber: String
    var passengerType: PassengerType
    
    enum IDType: String, CaseIterable {
        case idCard = "身份证"
        case passport = "护照"
        case other = "其他"
    }
    
    enum PassengerType: String, CaseIterable {
        case adult = "成人"
        case child = "儿童"
        case infant = "婴儿"
    }
}

// 附加服务
struct AdditionalService: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let price: Double
    var isSelected: Bool
    
    static let services = [
        AdditionalService(
            name: "接送机",
            description: "专车接送服务",
            price: 199,
            isSelected: false
        ),
        AdditionalService(
            name: "贵宾休息室",
            description: "享受舒适候机环境",
            price: 299,
            isSelected: false
        ),
        AdditionalService(
            name: "快速安检",
            description: "优先安检通道",
            price: 99,
            isSelected: false
        ),
        AdditionalService(
            name: "餐食升级",
            description: "享受精致餐食",
            price: 159,
            isSelected: false
        )
    ]
} 
