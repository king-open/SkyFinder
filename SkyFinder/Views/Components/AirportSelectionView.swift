import SwiftUI

/// 机场选择视图
/// 提供机场搜索和选择功能
struct AirportSelectionView: View {
    // MARK: - Properties
    /// 标签文本（出发地/目的地）
    let label: String
    /// 机场代码
    let code: String
    /// 城市名称
    let city: String
    /// 控制选择器显示状态
    @State private var isShowingPicker = false
    /// 搜索文本
    @State private var searchText = ""
    /// 视图模型引用
    @EnvironmentObject var viewModel: FlightBookingViewModel
    
    /// 选择回调
    var onSelect: ((String, String) -> Void)?
    
    // MARK: - Computed Properties
    /// 搜索建议列表
    var searchSuggestions: [Airport] {
        if searchText.isEmpty {
            return []
        }
        return viewModel.commonAirports.filter {
            $0.code.localizedCaseInsensitiveContains(searchText) ||
            $0.city.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var filteredAirports: [Airport] {
        if searchText.isEmpty {
            return viewModel.commonAirports
        } else {
            return viewModel.commonAirports.filter {
                $0.code.localizedCaseInsensitiveContains(searchText) ||
                $0.city.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var domesticAirports: [Airport] {
        filteredAirports.filter { 
            !$0.code.contains("NRT") && 
            !$0.code.contains("ICN")
        }
    }
    
    var internationalAirports: [Airport] {
        filteredAirports.filter { 
            $0.code.contains("NRT") || 
            $0.code.contains("ICN")
        }
    }
    
    var body: some View {
        Button {
            isShowingPicker.toggle()
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(label)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(code)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    Text(city)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Circle()
                    .fill(Color.backgroundBlue)
                    .frame(width: 40, height: 40)
                    .overlay {
                        Image(systemName: "arrow.up.arrow.down")
                            .foregroundColor(.white)
                    }
            }
            .padding(.horizontal)
            .padding(.vertical, 16)
        }
        .sheet(isPresented: $isShowingPicker) {
            NavigationStack {
                List {
                    Section {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            TextField("搜索城市或机场", text: $searchText)
                        }
                    }
                    
                    Section("国内机场") {
                        ForEach(domesticAirports) { airport in
                            AirportRow(code: airport.code, city: airport.city)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    onSelect?(airport.code, airport.city)
                                    isShowingPicker = false
                                }
                        }
                    }
                    
                    Section("国际机场") {
                        ForEach(internationalAirports) { airport in
                            AirportRow(code: airport.code, city: airport.city)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    onSelect?(airport.code, airport.city)
                                    isShowingPicker = false
                                }
                        }
                    }
                }
                .navigationTitle(label)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("完成") {
                            isShowingPicker = false
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "搜索城市或机场")
            .searchSuggestions {
                ForEach(searchSuggestions) { airport in
                    Button {
                        onSelect?(airport.code, airport.city)
                        isShowingPicker = false
                    } label: {
                        VStack(alignment: .leading) {
                            Text(airport.code)
                                .font(.headline)
                            Text(airport.city)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
    }
}

/// 机场列表项视图
struct AirportRow: View {
    let code: String
    let city: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(code)
                    .font(.headline)
                Text(city)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
    }
} 
