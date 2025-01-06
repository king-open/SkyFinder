import SwiftUI

struct MainTabView: View {
    @StateObject private var userViewModel = UserViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // 首页 - 机票搜索
            FlightBookingView()
                .tabItem {
                    Label("首页", systemImage: "airplane")
                }
                .tag(0)
            
            // 订单
            OrdersView()
                .tabItem {
                    Label("订单", systemImage: "list.bullet.rectangle")
                }
                .tag(1)
            
            // 发现 - 特价机票等
            DiscoveryView()
                .tabItem {
                    Label("发现", systemImage: "safari")
                }
                .tag(2)
            
            // 我的
            ProfileView()
                .tabItem {
                    Label("我的", systemImage: "person.fill")
                }
                .tag(3)
        }
        .environmentObject(userViewModel)
        .tint(.accentBlue)
    }
}

// 订单页面
struct OrdersView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var showingLogin = false  // 添加登录页面状态
    
    var body: some View {
        NavigationStack {
            if userViewModel.currentUser != nil {
                List {
                    ForEach(userViewModel.recentBookings) { flight in
                        FlightResultCard(
                            flight: flight,
                            mode: .order
                        )
                    }
                }
                .navigationTitle("我的订单")
            } else {
                // 未登录状态
                VStack(spacing: 20) {
                    Image(systemName: "person.circle")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    
                    Text("登录查看订单")
                        .font(.title2)
                    
                    Button("立即登录") {
                        showingLogin = true  // 显示登录页面
                    }
                    .buttonStyle(.bordered)
                }
                .navigationTitle("我的订单")
            }
        }
        .fullScreenCover(isPresented: $showingLogin) {  // 使用全屏模式显示登录页面
            LoginView()
        }
    }
}

// 发现页面
struct DiscoveryView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // 特价机票
                    PromotionCard(
                        title: "特价机票",
                        description: "北京 → 上海 ¥799起",
                        systemImage: "tag.fill"
                    )
                    
                    // 假日优惠
                    PromotionCard(
                        title: "假日优惠",
                        description: "五一特惠，提前购票享优惠",
                        systemImage: "gift.fill"
                    )
                    
                    // 会员专享
                    PromotionCard(
                        title: "会员专享",
                        description: "专属折扣，最高减¥500",
                        systemImage: "crown.fill"
                    )
                }
                .padding()
            }
            .navigationTitle("发现")
        }
    }
}

// 个人中心页面
struct ProfileView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var showingLogin = false  // 添加登录页面状态
    
    var body: some View {
        NavigationStack {
            if let user = userViewModel.currentUser {
                List {
                    // 用户信息
                    Section {
                        HStack(spacing: 15) {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 60))
                            
                            VStack(alignment: .leading) {
                                Text(user.name)
                                    .font(.headline)
                                if user.frequentFlyer {
                                    Text("常旅客会员")
                                        .font(.subheadline)
                                        .foregroundColor(.accentBlue)
                                }
                            }
                        }
                        .padding(.vertical, 10)
                    }
                    
                    // 会员服务
                    Section("会员服务") {
                        NavigationLink {
                            Text("积分: \(userViewModel.frequentFlyerPoints)")
                        } label: {
                            Label("我的积分", systemImage: "star.fill")
                        }
                        
                        NavigationLink {
                            Text("优惠券")
                        } label: {
                            Label("优惠券", systemImage: "ticket.fill")
                        }
                    }
                    
                    // 更多服务
                    Section("更多服务") {
                        NavigationLink {
                            Text("设置")
                        } label: {
                            Label("设置", systemImage: "gear")
                        }
                        
                        Button(role: .destructive) {
                            userViewModel.logout()
                        } label: {
                            Label("退出登录", systemImage: "rectangle.portrait.and.arrow.right")
                        }
                    }
                }
                .navigationTitle("我的")
            } else {
                VStack(spacing: 20) {
                    Image(systemName: "person.circle")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    
                    Text("登录体验更多功能")
                        .font(.title2)
                    
                    Button("立即登录") {
                        showingLogin = true  // 显示登录页面
                    }
                    .buttonStyle(.bordered)
                }
                .navigationTitle("我的")
            }
        }
        .fullScreenCover(isPresented: $showingLogin) {  // 使用全屏模式显示登录页面
            LoginView()
        }
    }
}

// 促销卡片组件
struct PromotionCard: View {
    let title: String
    let description: String
    let systemImage: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: systemImage)
                    .foregroundColor(.accentBlue)
                Text(title)
                    .font(.headline)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.cardWhite)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    MainTabView()
} 
