//
//  StatisticsService.swift
//  ToDo
//
//  Created by Тагир Файрушин on 19.03.2025.
//

import Foundation

class StatisticsService {
    
    private var totalToday: Int = 0
    private var totalWeek: Int = 0
    private var totalMonth: Int = 0
    private var daysPassedInWeek: Int = 1
    private var daysPassedInMonth: Int = 1
    
    var averagePerDay: Int {
        return totalToday
    }
    
    var averagePerWeek: Int {
        return Int(round(Double(totalWeek) / Double(daysPassedInWeek)))
    }

    var averagePerMonth: Int {
        return Int(round(Double(totalMonth) / Double(daysPassedInMonth)))
    }
    
    init(objects: [TodoEntity]) {
        calculateStatistics(from: objects)
    }
    
    func decrement() {
        totalWeek -= 1
        totalToday -= 1
        totalMonth -= 1
    }
    
    func calculateStatistics(from objects: [TodoEntity]) {
        let today = Date()
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        totalToday = objects.filter { todo in
            calendar.isDate(todo.finishedDate!, inSameDayAs: today)
        }.count
        
        if let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: today)?.start {
            daysPassedInWeek = calendar.dateComponents([.day], from: startOfWeek, to: today).day! + 1
            totalWeek = objects.filter { todo in
                todo.finishedDate! >= startOfWeek
            }.count
        }
        
        if let startOfMonth = calendar.dateInterval(of: .month, for: today)?.start {
            daysPassedInMonth = calendar.dateComponents([.day], from: startOfMonth, to: today).day! + 1
            totalMonth = objects.filter { todo in
                todo.finishedDate! >= startOfMonth
            }.count
        }
    }
    
    func getStatistics(for timeRange: TimeRange) -> Int {
        switch timeRange {
        case .day: return averagePerDay
        case .week: return averagePerWeek
        case .month: return averagePerMonth
        }
    }
}
