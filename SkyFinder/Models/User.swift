import Foundation

struct User: Identifiable, Codable {
    let id: String
    let name: String
    let avatar: String?
    let phoneNumber: String?
    let frequentFlyer: Bool
    let preferences: Preferences
    
    struct Preferences: Codable {
        let preferredClass: FlightClass
        let mealPreference: MealPreference
        let seatPreference: SeatPreference
    }
    
    enum FlightClass: String, Codable {
        case economy = "经济舱"
        case business = "商务舱"
        case first = "头等舱"
    }
    
    enum MealPreference: String, Codable {
        case regular = "普通餐"
        case vegetarian = "素食餐"
        case halal = "清真餐"
        case kosher = "犹太餐"
    }
    
    enum SeatPreference: String, Codable {
        case window = "靠窗"
        case aisle = "靠过道"
        case middle = "中间"
    }
} 
