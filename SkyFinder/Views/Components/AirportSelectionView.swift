import SwiftUI

struct AirportSelectionView: View {
    let label: String
    let code: String
    let city: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(code)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Text(city)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Circle()
                .fill(Color.backgroundBlue)
                .frame(width: 40, height: 40)
                .overlay {
                    Image(systemName: "arrow.up.arrow.down")
                        .foregroundColor(.white)
                }
        }
        .padding(.horizontal)
        .padding(.vertical, 16)
    }
} 
