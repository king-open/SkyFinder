import Foundation

class LoginViewModel: ObservableObject {
    @Published var phone = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var error: String?
    
    func login() {
        guard !phone.isEmpty, !password.isEmpty else {
            error = "请输入手机号和密码"
            return
        }
        
        isLoading = true
        
        // 模拟网络请求
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
            // 这里应该调用实际的登录API
            // 暂时直接模拟成功
            NotificationCenter.default.post(name: .userDidLogin, object: nil)
        }
    }
}

extension Notification.Name {
    static let userDidLogin = Notification.Name("userDidLogin")
} 
