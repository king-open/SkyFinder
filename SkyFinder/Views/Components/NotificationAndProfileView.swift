import SwiftUI

struct NotificationAndProfileView: View {
    var body: some View {
        HStack(spacing: 12) {
            NotificationButton()
            ProfileImage()
        }
    }
} 
