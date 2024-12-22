import Foundation

class SignupViewModel: ObservableObject {
    @Published var phone = ""
    @Published var verificationCode = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var error: String?
    
    // 验证码倒计时
    @Published var isCountingDown = false
    @Published var countdown = 60
    private var timer: Timer?
    
    // 发送验证码
    func sendVerificationCode() {
        guard !phone.isEmpty else {
            error = "请输入手机号"
            return
        }
        
        isLoading = true
        
        // 模拟网络请求发送验证码
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
            self.startCountdown()
        }
    }
    
    // 开始倒计时
    private func startCountdown() {
        isCountingDown = true
        countdown = 60
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            if self.countdown > 0 {
                self.countdown -= 1
            } else {
                self.stopCountdown()
            }
        }
    }
    
    // 停止倒计时
    private func stopCountdown() {
        timer?.invalidate()
        timer = nil
        isCountingDown = false
        countdown = 60
    }
    
    // 注册
    func signup() {
        guard !phone.isEmpty else {
            error = "请输入手机号"
            return
        }
        
        guard !verificationCode.isEmpty else {
            error = "请输入验证码"
            return
        }
        
        guard !password.isEmpty else {
            error = "请设置密码"
            return
        }
        
        isLoading = true
        
        // 模拟网络请求
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
            // 这里应该调用实际的注册API
            // 暂时直接模拟成功
            NotificationCenter.default.post(name: .userDidSignup, object: nil)
        }
    }
    
    deinit {
        stopCountdown()
    }
}

extension Notification.Name {
    static let userDidSignup = Notification.Name("userDidSignup")
} 
