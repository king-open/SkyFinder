import SwiftUI

/// 常用航线卡片视图
/// 显示用户的常用航线信息
struct FrequentRouteCard: View {
    /// 航线信息
    let route: FrequentRoute
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 机场代码
            HStack(spacing: 4) {
                Text(route.from)
                    .font(.system(size: 18, weight: .medium))
                Image(systemName: "arrow.right")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(route.to)
                    .font(.system(size: 18, weight: .medium))
            }
            
            // 城市名称
            HStack(spacing: 4) {
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
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(Color.cardWhite)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
} 
