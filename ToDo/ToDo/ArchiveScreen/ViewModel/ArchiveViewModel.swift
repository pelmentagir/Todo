//
//  ArchiveViewModel.swift
//  ToDo
//
//  Created by Тагир Файрушин on 12.03.2025.
//

import Foundation
import CoreData
import SwiftUI

class ArchiveViewModel: NSObject, ViewModel, ObservableObject {
    
    @Published var timeRange: TimeRange = .day
    @Published var data: [ChartsDataPoint] = []
    @Published var statistics: Int = 0
    
    private var statisticsService: StatisticsService?
    
    private var coreDataManager: CoreDataManager
    private var fetchResultController: NSFetchedResultsController<TodoEntity>
    
    var beginUpdateTableView: (() -> Void)?
    var endUpdateTableView: (() -> Void)?

    var deleteRowAt: ((IndexPath) -> Void)?
    var insertRowAt: ((IndexPath) -> Void)?
    
    var restoreTodo: ((TodoEntity) -> Void)?
    
    init(coreDataManager: CoreDataManager = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
        self.fetchResultController = coreDataManager.createFetchResultController()
        super.init()
        fetchResultController.delegate = self
        obtainData()
        self.statisticsService = StatisticsService(objects: fetchResultController.fetchedObjects ?? [])
    }
    
    func obtainData() {
        do {
            try fetchResultController.performFetch()
        } catch {
            print("Error obtain data: \(error)")
        }
    }
    
    // MARK: TableView - Data
    
    func getNumberOfSection() -> Int {
        fetchResultController.sections?.count ?? 0
    }
    
    func getNumberOfElementsInSection(_ section: Int) -> Int {
        return fetchResultController.sections?[section].numberOfObjects ?? 0
    }
    
    func getTodo(indexPath: IndexPath) -> TodoEntity {
        fetchResultController.object(at: indexPath)
    }
    
    func completedTodo(todo: any GeneralizedTodo) {
        let entity = todo as! TodoEntity
        entity.finishedDate = nil
        statisticsService?.decrement()
        try? coreDataManager.viewContext.save()
        restoreTodo?(entity)
    }

    func deleteTodoFromCoreData(entity: TodoEntity) {
        coreDataManager.deleteTodo(todo: entity)
        statisticsService?.decrement()
        updateData()
    }
    
    // MARK: Calendar methods
    
    func getTodosAtTimeRange(timeRange: TimeRange) -> [ChartsDataPoint] {
        switch timeRange {
        case .day: return getTodayTodos()
        case .week: return getWeekTodos()
        case .month: return getMonthTodos()
        }
    }
    
    func timeDifference(from startDate: Date, to endDate: Date) -> String {
        let componentsFormatter = DateComponentsFormatter()
        componentsFormatter.allowedUnits = [.hour, .minute]
        componentsFormatter.unitsStyle = .abbreviated
        return componentsFormatter.string(from: startDate, to: endDate) ?? ""
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter.string(from: date)
    }
    
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    func formatDateForTimeRange(_ date: Date) -> String {
        let formatter = DateFormatter()
        
        switch timeRange {
        case .day:
            return formatHourRange(date)
        case .week, .month:
            formatter.dateFormat = "d MMMM yyyy"
            return formatter.string(from: date)
        }
    }
    
    func formatHourRange(_ date: Date) -> String{
        let calendar = Calendar.current
        
        let startHour = calendar.component(.hour, from: date)
        let endHour = (startHour + 1) % 24
        
        let dataFormatter = DateFormatter()
        dataFormatter.dateFormat = "ha"
        dataFormatter.amSymbol = "AM"
        dataFormatter.pmSymbol = "PM"
        
        let startHourString = dataFormatter.string(from: calendar.date(bySettingHour: startHour, minute: 0, second: 0, of: date)!)
        let endHourString = dataFormatter.string(from: calendar.date(bySettingHour: endHour, minute: 0, second: 0, of: date)!)
        
        return "\(startHourString) - \(endHourString)"
    }
    
    func getTodayTodos() -> [ChartsDataPoint] {
        var hourlyData: [ChartsDataPoint] = []
        let calendar = Calendar.current
        
        for hour in 0..<24 {
            let startOfHour = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: Date())!
            let endOfHour = calendar.date(bySettingHour: hour, minute: 59, second: 59, of: Date())!
            
            let todosInHour = fetchResultController.fetchedObjects?.filter { todo in
                if let finishedDate = todo.finishedDate {
                    return finishedDate >= startOfHour && finishedDate <= endOfHour
                }
                return false
            } ?? []
            
            hourlyData.append(ChartsDataPoint(date: startOfHour, count: todosInHour.count))
        }
        
        return hourlyData
    }
    
    func getWeekTodos() -> [ChartsDataPoint] {
        let calendar = Calendar.current
        guard let startOfWeek = calendar.startOfWeek(for: Date()) else { return [] }

        var weeklyData: [ChartsDataPoint] = []
        
        for i in 0..<7 {
            let day = calendar.date(byAdding: .day, value: i, to: startOfWeek)!
            let dayStart = calendar.startOfDay(for: day)
            let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart)!

            let todosOnDay = fetchResultController.fetchedObjects?.filter { todo in
                if let finishedDate = todo.finishedDate {
                    return finishedDate >= dayStart && finishedDate < dayEnd
                }
                return false
            } ?? []

            weeklyData.append(ChartsDataPoint(date: day, count: todosOnDay.count))
        }

        return weeklyData
    }
    
    func getMonthTodos() -> [ChartsDataPoint] {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        guard let startOfMonth = calendar.dateInterval(of: .month, for: Date())?.start, let objects = fetchResultController.fetchedObjects else { return [] }
        
        let dayQuantity = calendar.range(of: .day, in: .month, for: startOfMonth)?.count ?? 0
        var todosByDay:[Date:Int] = [:]
        
        for todo in objects {
            todosByDay[calendar.startOfDay(for: todo.finishedDate!), default: 0] += 1
        }
        
        var monthData: [ChartsDataPoint] = []
        for dayOffset in 0 ..< dayQuantity {
            let day = calendar.date(byAdding: .day, value: dayOffset, to: startOfMonth)!
            let dayStart = calendar.startOfDay(for: day)
            
            let count = todosByDay[dayStart] ?? 0
            monthData.append(ChartsDataPoint(date: dayStart, count: count))
        }
        return monthData
    }
    
    func updateData() {
        statistics = statisticsService?.getStatistics(for: timeRange) ?? 0
        data = getTodosAtTimeRange(timeRange: timeRange)
    }
    
    func getBarkMarkSize() -> CGFloat {
        Constant.BarMarkSize.withTimeRange(timeRange).getVal
    }
    
    func getCountAllObjects() -> Int {
        fetchResultController.fetchedObjects?.count ?? 0
    }
}


extension ArchiveViewModel: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        beginUpdateTableView?()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        endUpdateTableView?()
        self.updateData()
    }
    
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            
        case .insert:
            if let newIndexPath {
                insertRowAt?(newIndexPath)
            }
            
        case .delete:
            if let indexPath {
                deleteRowAt?(indexPath)
            }
            
        case .move:
            break
            
        case .update:
            break
            
        @unknown default:
            fatalError("Unhandled NSFetchedResultsChangeType")
        }
    }
}
