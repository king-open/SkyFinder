import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                // 标题
                Text("欢迎回来")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // 输入表单
                VStack(spacing: 20) {
                    // 手机号
                    TextField("手机号", text: $viewModel.phone)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedTextFieldStyle())
                    
                    // 密码
                    SecureField("密码", text: $viewModel.password)
                        .textFieldStyle(RoundedTextFieldStyle())
                    
                    // 忘记密码
                    HStack {
                        Spacer()
                        Button("忘记密码？") {
                            // 处理忘记密码
                        }
                        .foregroundColor(.gray)
                    }
                }
                
                // 登录按钮
                Button {
                    viewModel.login()
                } label: {
                    Text("登录")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentBlue)
                        .clipShape(Capsule())
                }
                
                // 其他登录方式
                VStack(spacing: 20) {
                    Text("其他登录方式")
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 30) {
                        SocialLoginButton(image: "wechat", action: { /* 微信登录 */ })
                        SocialLoginButton(image: "apple", action: { /* Apple登录 */ })
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// 自定义圆角输入框样式
struct RoundedTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// 社交登录按钮
struct SocialLoginButton: View {
    let image: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(image)
                .resizable()
                .frame(width: 44, height: 44)
                .padding()
                .background(Color.gray.opacity(0.1))
                .clipShape(Circle())
        }
    }
} 
