import SwiftUI

struct ActionButtonsView: View {
    @Binding var date: Date
    @Binding var isRoundTrip: Bool
    @Binding var returnDate: Date
    @Binding var filter: FlightFilter
    
    var body: some View {
        HStack(spacing: 12) {
            DateSelectionButton(date: $date)
            
            ReturnButton(
                isRoundTrip: $isRoundTrip,
                returnDate: $returnDate
            )
            
            FilterButton(filter: $filter)
        }
    }
}
