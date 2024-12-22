import SwiftUI

struct FlightFilterView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var filter: FlightFilter
    
    var body: some View {
        NavigationStack {
            Form {
                // 价格区间
                Section("价格区间") {
                    PriceRangeSlider(range: $filter.priceRange)
                }
                
                // 航空公司
                Section("航空公司") {
                    ForEach(["国航", "东航", "南航", "海航"], id: \.self) { airline in
                        Toggle(airline, isOn: .init(
                            get: { filter.airlines.contains(airline) },
                            set: { isSelected in
                                if isSelected {
                                    filter.airlines.insert(airline)
                                } else {
                                    filter.airlines.remove(airline)
                                }
                            }
                        ))
                    }
                }
                
                // 起飞时间
                Section("起飞时间") {
                    DatePicker("从", selection: .init(
                        get: { filter.departureTimeRange.lowerBound },
                        set: { filter.departureTimeRange = $0...filter.departureTimeRange.upperBound }
                    ), displayedComponents: [.hourAndMinute])
                    
                    DatePicker("至", selection: .init(
                        get: { filter.departureTimeRange.upperBound },
                        set: { filter.departureTimeRange = filter.departureTimeRange.lowerBound...$0 }
                    ), displayedComponents: [.hourAndMinute])
                }
                
                // 舱位
                Section("舱位") {
                    Picker("舱位类型", selection: $filter.cabinClass) {
                        ForEach(FlightFilter.CabinClass.allCases, id: \.self) { cabinClass in
                            Text(cabinClass.rawValue).tag(cabinClass)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                // 其他选项
                Section {
                    Toggle("只看直飞", isOn: $filter.directFlightsOnly)
                }
            }
            .navigationTitle("筛选")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("重置") {
                        filter = FlightFilter()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// 价格区间滑块
struct PriceRangeSlider: View {
    @Binding var range: ClosedRange<Double>
    
    var body: some View {
        VStack {
            HStack {
                Text("¥\(Int(range.lowerBound))")
                Spacer()
                Text("¥\(Int(range.upperBound))")
            }
            .font(.caption)
            .foregroundColor(.gray)
            
            RangeSlider(range: $range, in: 0...10000)
                .frame(height: 44)
        }
    }
}

// 自定义范围滑块
struct RangeSlider: View {
    @Binding var range: ClosedRange<Double>
    let bounds: ClosedRange<Double>
    
    init(range: Binding<ClosedRange<Double>>, in bounds: ClosedRange<Double>) {
        self._range = range
        self.bounds = bounds
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 4)
                
                Rectangle()
                    .fill(Color.accentBlue)
                    .frame(width: width(in: geometry), height: 4)
                    .offset(x: position(in: geometry))
                
                HStack(spacing: 0) {
                    Circle()
                        .fill(.white)
                        .frame(width: 24, height: 24)
                        .shadow(radius: 4)
                        .gesture(dragGesture(for: \ClosedRange.lowerBound, in: geometry))
                    
                    Circle()
                        .fill(.white)
                        .frame(width: 24, height: 24)
                        .shadow(radius: 4)
                        .gesture(dragGesture(for: \ClosedRange.upperBound, in: geometry))
                }
                .position(x: position(in: geometry) + width(in: geometry) / 2,
                         y: geometry.size.height / 2)
            }
        }
    }
    
    private func position(in geometry: GeometryProxy) -> CGFloat {
        let lowerBound = range.lowerBound
        let total = bounds.upperBound - bounds.lowerBound
        return (lowerBound - bounds.lowerBound) / total * geometry.size.width
    }
    
    private func width(in geometry: GeometryProxy) -> CGFloat {
        let total = bounds.upperBound - bounds.lowerBound
        return (range.upperBound - range.lowerBound) / total * geometry.size.width
    }
    
    private func dragGesture(
        for bound: KeyPath<ClosedRange<Double>, Double>,
        in geometry: GeometryProxy
    ) -> some Gesture {
        DragGesture()
            .onChanged { value in
                let total = bounds.upperBound - bounds.lowerBound
                let ratio = value.location.x / geometry.size.width
                let newValue = bounds.lowerBound + total * ratio
                
                if bound == \ClosedRange.lowerBound {
                    range = Swift.max(bounds.lowerBound, Swift.min(newValue, range.upperBound))...range.upperBound
                } else {
                    range = range.lowerBound...Swift.min(bounds.upperBound, Swift.max(newValue, range.lowerBound))
                }
            }
    }
} 
