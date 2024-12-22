import SwiftUI

/// 错误提示弹窗修饰器
/// 用于统一处理错误提示的显示
struct ErrorAlert: ViewModifier {
    /// 错误信息
    let error: String?
    /// 控制弹窗显示状态
    @Binding var isPresented: Bool
    
    func body(content: Content) -> some View {
        content
            .alert("提示", isPresented: .constant(error != nil)) {
                Button("确定") {
                    isPresented = false
                }
            } message: {
                if let error = error {
                    Text(error)
                }
            }
    }
}

// MARK: - View Extension
extension View {
    /// 为视图添加错误提示弹窗
    /// - Parameters:
    ///   - error: 错误信息
    ///   - isPresented: 控制弹窗显示的绑定值
    func errorAlert(error: String?, isPresented: Binding<Bool>) -> some View {
        modifier(ErrorAlert(error: error, isPresented: isPresented))
    }
} 
