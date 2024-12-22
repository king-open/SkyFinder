import Foundation

struct FlightFilter {
    var priceRange: ClosedRange<Double> = 0...10000
    var airlines: Set<String> = []
    var departureTimeRange: ClosedRange<Date>
    var arrivalTimeRange: ClosedRange<Date>
    var cabinClass: CabinClass = .economy
    var directFlightsOnly: Bool = false
    
    enum CabinClass: String, CaseIterable {
        case economy = "经济舱"
        case business = "商务舱"
        case first = "头等舱"
    }
    
    init() {
        let calendar = Calendar.current
        let today = Date()
        let startOfDay = calendar.startOfDay(for: today)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        self.departureTimeRange = startOfDay...endOfDay
        self.arrivalTimeRange = startOfDay...endOfDay
    }
} 
