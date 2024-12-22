import Foundation

struct Flight: Identifiable {
    let id = UUID()
    let departure: String
    let arrival: String
    let departureCity: String
    let arrivalCity: String
    let departureTime: String
    let arrivalTime: String
    let duration: String
    let transfers: String
    let price: String
    let airline: String
    let isInternational: Bool
} 
