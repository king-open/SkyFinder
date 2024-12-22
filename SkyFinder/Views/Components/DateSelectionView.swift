import SwiftUI

struct DateSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedDate: Date
    
    // 获取选中日期的价格信息
    private func getPriceForDate(_ date: Date) -> (lowest: String, normal: String) {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        
        // 根据星期几返回不同价格
        // 周末价格较高，工作日价格较低
        switch weekday {
        case 1, 7: // 周末
            return ("¥1580", "¥1880")
        case 6: // 周五
            return ("¥1480", "¥1780")
        default: // 工作日
            return ("¥1280", "¥1580")
        }
    }
    
    // 格式化日期
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "M月d日, EEEE"
        return formatter.string(from: date)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // 显示选中的日期
                Text(formatDate(selectedDate))
                    .font(.headline)
                    .foregroundColor(.accentBlue)
                
                // 日历视图
                DatePicker(
                    "选择日期",
                    selection: $selectedDate,
                    in: Date()..., // 只能选择今天及以后的日期
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .padding()
                
                // 价格信息
                let price = getPriceForDate(selectedDate)
                VStack(spacing: 12) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("当日最低价")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(price.lowest)
                                .foregroundColor(.accentBlue)
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("平时价格")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(price.normal)
                                .foregroundColor(.gray)
                                .strikethrough()
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
                
                Spacer()
                
                // 确认按钮
                Button {
                    dismiss()
                } label: {
                    Text("确认选择")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentBlue)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding()
            }
            .navigationTitle("选择出发日期")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("取消") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    DateSelectionView(selectedDate: .constant(Date()))
} 
