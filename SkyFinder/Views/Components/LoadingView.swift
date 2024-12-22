import SwiftUI

/// 通用加载视图组件
/// 显示加载动画和提示文本
struct LoadingView: View {
    /// 加载提示文本
    let text: String
    
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text(text)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.3))
    }
}

#Preview {
    LoadingView(text: "加载中...")
}
