import Foundation

class FlightBookingViewModel: ObservableObject {
    @Published var fromAirport = "CDG"
    @Published var toAirport = "JFK"
    @Published var fromCity = "巴黎, 法国"
    @Published var toCity = "纽约, 美国"
    @Published var selectedDate = Date()
    @Published var flights: [Flight] = []
    
    init() {
        // 模拟数据
        flights = [
            Flight(
                departure: "CDG",
                arrival: "DUB",
                departureCity: "巴黎, 法国",
                arrivalCity: "都柏林, 爱尔兰",
                departureTime: "02:00 AM",
                arrivalTime: "06:00 AM",
                duration: "12 hr",
                transfers: "1 transfer",
                price: "$120.00",
                airline: "airTran"
            ),
            Flight(
                departure: "CDG",
                arrival: "JFK",
                departureCity: "巴黎, 法国",
                arrivalCity: "纽约, 美国",
                departureTime: "02:00 AM",
                arrivalTime: "10:00 AM",
                duration: "8 hr",
                transfers: "no transfers",
                price: "$120.00",
                airline: "AIRBUS"
            )
        ]
    }
    
    func searchFlights() {
        // 这里可以添加实际的搜索逻辑
    }
    
    func swapAirports() {
        let tempAirport = fromAirport
        let tempCity = fromCity
        
        fromAirport = toAirport
        fromCity = toCity
        
        toAirport = tempAirport
        toCity = tempCity
    }
} 
