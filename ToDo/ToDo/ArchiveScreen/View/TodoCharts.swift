//
//  TodoCharts.swift
//  ToDo
//
//  Created by Тагир Файрушин on 17.03.2025.
//

import SwiftUI
import Charts

struct TodoCharts: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var archiveViewModel: ArchiveViewModel
    @State private var rawSelectedDate: Date?
    
    private var unit: Calendar.Component {
        switch archiveViewModel.timeRange {
        case .day: return .hour
        case .week: return .weekday
        case .month: return .day
        }
    }
    
    private var selectedChartDataPoint: ChartsDataPoint? {
        guard let rawSelectedDate else { return nil }
        return archiveViewModel.data.first {
            Calendar.current.isDate(rawSelectedDate, equalTo: $0.date, toGranularity: unit)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Task Statistics")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.horizontal, 8)
            
            Picker("Period", selection: $archiveViewModel.timeRange) {
                ForEach(TimeRange.allCases, id: \ .self) { timeRange in
                    Text(timeRange.rawValue).tag(timeRange)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 8)
            
            statisticsView
                .padding(.horizontal, 8)
            
            chartView
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(backgroundRectangleView)
                .padding(.horizontal, 4)
        }
        .padding(.vertical, 4)
        .onAppear {
            archiveViewModel.updateData()
        }
        .onChange(of: archiveViewModel.timeRange) { _, _ in
            archiveViewModel.updateData()
        }
    }
    
    private var statisticsView: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(statisticsTitle)
                .font(.callout)
                .foregroundColor(.gray)
                .fontWeight(.semibold)
            
            Text("\(archiveViewModel.statistics)")
                .font(.system(size: 28))
                .foregroundColor(Color(IconColorManager.shared.currentColor))
                .fontWeight(.semibold)
            
            Text(statisticsSubtitle)
                .font(.subheadline)
                .foregroundColor(.gray)
                .fontWeight(.semibold)
        }
    }
    
    private var statisticsTitle: String {
        archiveViewModel.timeRange == .day ? "Total" : "On average per day"
    }
    
    private var statisticsSubtitle: String {
        switch archiveViewModel.timeRange {
        case .day: return "For today"
        case .week: return "This week"
        case .month: return currentMonthAndYear
        }
    }
    
    private var currentMonthAndYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: Date()).capitalized
    }
    
    private var chartView: some View {
        
        Chart {
            if let selectedChartDataPoint {
                RuleMark(x: .value("Selected Day", selectedChartDataPoint.date, unit: unit),
                         yStart: -20)
                                
                    .foregroundStyle(.secondary.opacity(0.3))
                    .annotation(position: .top, overflowResolution: .init(x: .fit(to: .chart), y: .disabled)) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("TOTAL")
                                .font(.caption)
                                .bold()
                            Text("\(selectedChartDataPoint.count)")
                                .font(.title.bold())
                                .baselineOffset(4)
                            Text(archiveViewModel.formatDateForTimeRange(selectedChartDataPoint.date))
                                .font(.footnote)
                                .bold()
                        }
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .frame(width: 120, alignment: .leading)
                        .background(RoundedRectangle(cornerRadius: 6).fill(Color(IconColorManager.shared.currentColor).gradient))
                    }
            }
            ForEach(archiveViewModel.data) { dataPoint in
                BarMark(
                    x: .value("Date", dataPoint.date, unit: unit),
                    y: .value("Value", dataPoint.count)
                )
                .cornerRadius(5)
                .foregroundStyle(Color(IconColorManager.shared.currentColor).gradient)
                .opacity(rawSelectedDate == nil || dataPoint.date == selectedChartDataPoint?.date ? 1.0 : 0.3)
                .annotation(position: .top) {
                    if dataPoint.count > 0 {
                        Text("\(dataPoint.count)")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(4)
                    }
                }
            }
        }
        .chartXAxis {
            if archiveViewModel.timeRange == .week {
                AxisMarks(position: .bottom, values: archiveViewModel.data.map { $0.date }) { date in
                    AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                }
            } else {
                AxisMarks()
            }
        }
        .chartXSelection(value: $rawSelectedDate.animation(.easeInOut))
        .frame(height: 200)
        .padding()
    }
    
    
    private var backgroundRectangleView: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(.background)
            .shadow(color: (colorScheme == .dark ? .white.opacity(0.15) : .black.opacity(0.15)), radius: 10, x: 0, y: 5)
    }
}
