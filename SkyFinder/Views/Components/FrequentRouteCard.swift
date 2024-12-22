struct FrequentRouteCard: View {
    let route: FrequentRoute
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(route.from)
                    .font(.headline)
                Image(systemName: "arrow.right")
                    .font(.caption)
                Text(route.to)
                    .font(.headline)
            }
            
            HStack {
                Text(route.fromCity)
                    .font(.caption)
                    .foregroundColor(.gray)
                Image(systemName: "arrow.right")
                    .font(.caption2)
                    .foregroundColor(.gray)
                Text(route.toCity)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.cardWhite)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
} 
