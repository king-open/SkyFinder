import Network

/// 网络状态监控器
/// 用于监控设备的网络连接状态
class NetworkMonitor: ObservableObject {
    /// 网络监控器实例
    private let monitor = NWPathMonitor()
    /// 监控队列
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    /// 网络连接状态
    @Published var isConnected = true
    
    init() {
        // 设置网络状态变化处理
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        // 启动监控
        monitor.start(queue: queue)
    }
    
    deinit {
        // 停止监控
        monitor.cancel()
    }
} 
