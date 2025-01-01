import SwiftUI

struct PaymentView: View {
    @Environment(\.dismiss) private var dismiss
    let flight: Flight
    let isRoundTrip: Bool
    let returnFlight: Flight?
    
    @State private var selectedPaymentMethod = PaymentMethod.wechat
    @State private var isProcessing = false
    @State private var showingResult = false
    @State private var paymentSuccess = false
    @State private var showingBoardingPass = false
    @State private var shouldDismiss = false
    
    enum PaymentMethod: String, CaseIterable {
        case wechat = "微信支付"
        case alipay = "支付宝"
        case unionpay = "银联"
    }
    
    var totalAmount: String {
        let outboundPrice = Double(flight.price.dropFirst()) ?? 0
        let returnPrice = isRoundTrip ? (Double(returnFlight?.price.dropFirst() ?? "0") ?? 0) : 0
        return "¥\(Int(outboundPrice + returnPrice))"
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // 价格摘要
                    VStack(spacing: 16) {
                        Text(totalAmount)
                            .font(.system(size: 44, weight: .bold))
                            .foregroundColor(.accentBlue)
                        
                        Text("总价")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.cardWhite)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    // 航班信息
                    VStack(alignment: .leading, spacing: 20) {
                        Text("航班信息")
                            .font(.headline)
                        
                        // 去程
                        FlightInfoRow(
                            from: flight.departure,
                            fromCity: flight.departureCity,
                            to: flight.arrival,
                            toCity: flight.arrivalCity,
                            time: flight.departureTime,
                            price: flight.price
                        )
                        
                        // 返程
                        if isRoundTrip, let returnFlight = returnFlight {
                            Divider()
                            FlightInfoRow(
                                from: returnFlight.departure,
                                fromCity: returnFlight.departureCity,
                                to: returnFlight.arrival,
                                toCity: returnFlight.arrivalCity,
                                time: returnFlight.departureTime,
                                price: returnFlight.price
                            )
                        }
                    }
                    .padding()
                    .background(Color.cardWhite)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    // 支付方式
                    VStack(alignment: .leading, spacing: 20) {
                        Text("支付方式")
                            .font(.headline)
                        
                        ForEach(PaymentMethod.allCases, id: \.self) { method in
                            PaymentMethodRow(
                                method: method,
                                isSelected: selectedPaymentMethod == method
                            )
                            .onTapGesture {
                                selectedPaymentMethod = method
                            }
                        }
                    }
                    .padding()
                    .background(Color.cardWhite)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding()
            }
            .navigationTitle("支付")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                Button {
                    processPayment()
                } label: {
                    if isProcessing {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("确认支付")
                            .font(.headline)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentBlue)
                .foregroundColor(.white)
                .disabled(isProcessing)
            }
            .alert("支付结果", isPresented: $showingResult) {
                Button("确定") { }
            } message: {
                Text(paymentSuccess ? "支付成功，正在生成登机牌..." : "支付失败，请重试")
            }
            .onChange(of: shouldDismiss) { newValue in
                if newValue {
                    dismiss()
                }
            }
            .fullScreenCover(isPresented: $showingBoardingPass) {
                if isRoundTrip {
                    TabView {
                        BoardingPassView(flight: flight)
                            .tabItem {
                                Label("去程", systemImage: "airplane.departure")
                            }
                        
                        if let returnFlight = returnFlight {
                            BoardingPassView(flight: returnFlight)
                                .tabItem {
                                    Label("返程", systemImage: "airplane.arrival")
                                }
                        }
                    }
                } else {
                    BoardingPassView(flight: flight)
                }
            }
        }
    }
    
    private func processPayment() {
        isProcessing = true
        
        // 模拟支付过程，延长到3秒
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            isProcessing = false
            paymentSuccess = true
            showingResult = true
            
            // 支付成功后，延迟2秒再显示登机牌
            if paymentSuccess {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    shouldDismiss = true
                    showingBoardingPass = true
                }
            }
        }
    }
}

// 航班信息行
struct FlightInfoRow: View {
    let from: String
    let fromCity: String
    let to: String
    let toCity: String
    let time: String
    let price: String
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text(from)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(fromCity)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: "arrow.right")
                    .foregroundColor(.gray)
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(to)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(toCity)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            HStack {
                Text(time)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text(price)
                    .font(.headline)
                    .foregroundColor(.accentBlue)
            }
        }
    }
}

// 支付方式行
struct PaymentMethodRow: View {
    let method: PaymentView.PaymentMethod
    let isSelected: Bool
    
    var body: some View {
        HStack {
            Image(method.rawValue)
                .resizable()
                .frame(width: 32, height: 32)
            
            Text(method.rawValue)
                .font(.headline)
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.accentBlue)
            }
        }
        .padding()
        .background(isSelected ? Color.accentBlue.opacity(0.1) : .clear)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
} 
