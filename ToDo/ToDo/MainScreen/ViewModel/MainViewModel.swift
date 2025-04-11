//
//  MainViewModel.swift
//  ToDo
//
//  Created by Тагир Файрушин on 08.02.2025.
//

import Foundation

class MainViewModel: ViewModel {
    
    private var coreDataManager = CoreDataManager.shared
    
    private lazy var heightSoonerCell: CGFloat = Constant.TableViewSize.defaultHeight
    private lazy var heightLaterCell: CGFloat = Constant.TableViewSize.defaultHeight
    
    lazy var keyboardState: Bool = false
    private var expandedHeader: HeaderType?

    var onHeightAndButtonUpdate: ((HeaderType, CGFloat, CGFloat) -> Void)?
    var changeHeader: (() -> Void)?
    var updateHeightCell: (() -> Void)?
    
    var updateTableBackground: (() -> Void)?
    var updateSnaphot: ((ActionTypes, Todo, Todo?) -> Void)?
    
    var counterTask: ((Int, HeaderType) -> Void)?
    
    init() {
        loadTodos()
    }
    
    deinit {
        coreDataManager.saveTodos(soonerTodos: todoSooner, laterTodos: todoLater)
    }
    
    private(set) lazy var todoSooner: [Todo] = [] {
        didSet {
            counterTask?(todoSooner.count, .soon)
        }
    }
    
    private(set) lazy var todoLater: [Todo] = [] {
        didSet {
            counterTask?(todoLater.count, .later)
        }
    }
    
    private var expandedHeight: CGFloat {
        keyboardState ? Constant.TableViewSize.fullScreenHeightOnKeyboard - 2 : Constant.TableViewSize.fullScreenHeight - 2
    }

    private var defaultHeight: CGFloat {
        keyboardState ? Constant.TableViewSize.defaultHeightOnKeyboard - 1 : Constant.TableViewSize.defaultHeight - 1
    }
    
    func loadTodos() {
        let (todosSonner, todosLater) = coreDataManager.obtainTodos()
        todoSooner = todosSonner
        todoLater = todosLater
    }

    func changeKeyboardState() {
        keyboardState.toggle()
        toggleHeader(expandedHeader)
        changeHeader?()
    }
    
    func changeKeyboardStateEdittingStyle() {
        keyboardState.toggle()
        toggleHeader(expandedHeader)
        updateHeightCell?()
    }

    func expandOrCollapseAction(selectedHeader: HeaderType) {
        toggleHeader(selectedHeader)
        onHeightAndButtonUpdate?(selectedHeader, heightSoonerCell, heightLaterCell)
    }

    func headerGesture(state: StateGesture) {
        let targetHeader: HeaderType = (state == .up) ? .later : .soon

        if heightLaterCell != heightSoonerCell {
            heightSoonerCell = defaultHeight
            heightLaterCell = defaultHeight
            expandedHeader = nil
        } else {
            toggleHeader(targetHeader)
        }

        onHeightAndButtonUpdate?(targetHeader, heightSoonerCell, heightLaterCell)
    }

    private func toggleHeader(_ header: HeaderType?) {
        if let header = header {
            let isExpanded = (header == .soon && heightSoonerCell == expandedHeight) ||
                             (header == .later && heightLaterCell == expandedHeight)

            heightSoonerCell = isExpanded ? defaultHeight : (header == .soon ? expandedHeight : Constant.TableViewSize.zeroHeight)
            heightLaterCell  = isExpanded ? defaultHeight : (header == .later ? expandedHeight : Constant.TableViewSize.zeroHeight)

            expandedHeader = isExpanded ? nil : header
        } else {
            heightSoonerCell = defaultHeight
            heightLaterCell = defaultHeight
            expandedHeader = nil
        }
    }

    func heightForRow(section: Int) -> CGFloat {
        return section == 0 ? heightSoonerCell : heightLaterCell
    }
    
    func appendTodoBySection(_ todo: Todo, section: HeaderType) {
        switch section {
        case .soon: todoSooner.append(todo)
        case .later:
            todoLater.append(todo)
        }
        updateSnaphot?(.add, todo, nil)
    }
    
    func moveTodoToAnotherSection(todo: Todo) {
        guard let index = (todo.section == .soon ? todoSooner : todoLater)
                .firstIndex(where: { $0.id == todo.id }) else { return }
        
        if todo.section == .soon {
            var todo = todoSooner.remove(at: index)
            updateSnaphot?(.remove, todo, nil)
            todo.section = .later
            todoLater.append(todo)
            updateSnaphot?(.add, todo, nil)
        } else {
            var todo = todoLater.remove(at: index)
            updateSnaphot?(.remove, todo, nil)
            todo.section = .soon
            todoSooner.append(todo)
            updateSnaphot?(.add, todo, nil)
        }
    }
    
    func completedTodo(todo: GeneralizedTodo) {
        guard let todo = todo as? Todo else { return }
        
        guard let index = (todo.section == .soon ? todoSooner : todoLater)
                .firstIndex(where: { $0.id == todo.id }) else { return }
        
        if todo.section == .soon {
            let todo = todoSooner.remove(at: index)
            updateSnaphot?(.remove, todo, nil)
            coreDataManager.saveCompletedTodo(todo: todo)
        } else {
            let todo = todoLater.remove(at: index)
            updateSnaphot?(.remove, todo, nil)
            coreDataManager.saveCompletedTodo(todo: todo)
        }
    }
    
    func editTodo(todo: Todo, newText: String) {
        
        guard let index = (todo.section == .soon ? todoSooner : todoLater)
                .firstIndex(where: { $0.id == todo.id }) else { return }
        
        switch todo.section {
        case .soon:
            let oldTodo = todoSooner[index]
            todoSooner[index].renameTitle(newText: newText)
            updateSnaphot?(.editing, todoSooner[index], oldTodo)
        case .later:
            let oldTodo = todoLater[index]
            todoLater[index].renameTitle(newText: newText)
            updateSnaphot?(.editing, todoLater[index], oldTodo)
        }
    }
}
