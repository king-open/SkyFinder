import SwiftUI

extension View {
    func standardButtonStyle() -> some View {
        self.shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 4)
    }
    
    func floatingButtonStyle() -> some View {
        self
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
            .shadow(color: .black.opacity(0.1), radius: 16, x: 0, y: 4)
    }
} 
