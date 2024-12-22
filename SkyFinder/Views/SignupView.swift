import SwiftUI

struct SignupView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = SignupViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                // 标题
                Text("创建账号")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // 输入表单
                VStack(spacing: 20) {
                    TextField("手机号", text: $viewModel.phone)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedTextFieldStyle())
                    
                    HStack {
                        TextField("验证码", text: $viewModel.verificationCode)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedTextFieldStyle())
                        
                        Button(viewModel.isCountingDown ? "\(viewModel.countdown)s" : "获取验证码") {
                            viewModel.sendVerificationCode()
                        }
                        .disabled(viewModel.isCountingDown)
                        .foregroundColor(viewModel.isCountingDown ? .gray : .accentBlue)
                    }
                    
                    SecureField("设置密码", text: $viewModel.password)
                        .textFieldStyle(RoundedTextFieldStyle())
                }
                
                // 注册按钮
                Button {
                    viewModel.signup()
                } label: {
                    Text("注册")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentBlue)
                        .clipShape(Capsule())
                }
                
                // 用户协议
                Text("注册即代表同意《用户协议》和《隐私政策》")
                    .font(.footnote)
                    .foregroundColor(.gray)
                
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
