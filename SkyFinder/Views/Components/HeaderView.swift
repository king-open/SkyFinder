import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack {
            Text("预订您的\n下一趟航班")
                .font(.title)
                .fontWeight(.bold)
            
            Spacer()
            
            NotificationAndProfileView()
        }
    }
} 
