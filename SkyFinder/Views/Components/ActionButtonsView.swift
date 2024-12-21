import SwiftUI

struct ActionButtonsView: View {
    @Binding var date: Date
    
    var body: some View {
        HStack(spacing: 12) {
            DateSelectionButton(date: date)
            ReturnButton()
            FilterButton()
        }
    }
} 
