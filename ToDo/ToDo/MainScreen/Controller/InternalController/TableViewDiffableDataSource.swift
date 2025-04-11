//
//  TableViewDiffableDataSource.swift
//  ToDo
//
//  Created by Тагир Файрушин on 01.03.2025.
//

import UIKit

class TableViewDiffableDataSource: NSObject {
    private var tableView: UITableView
    private(set) var dataSource: UITableViewDiffableDataSource<TableViewSection, Todo>?
    private(set) var viewModel: MainViewModel
    private(set) var section: HeaderType
    
    private var availableCells: [TodoTableViewCell] = []
    
    private lazy var moveToAnotherSectionAction = UIAction { [weak self] event in
        guard let self else { return }
        if let button = event.sender as? UIButton {
            if let superView = button.superview?.superview?.superview as? TodoTableViewCell {
                viewModel.moveTodoToAnotherSection(todo: superView.todo! as! Todo) 
            }
        }
    }

    init(tableView: UITableView, viewModel: MainViewModel, section: HeaderType) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.section = section
        super.init()
        setupDataSource()
    }

    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView) { [weak self] tableView, indexPath, todo in
            guard let self else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableViewCell.reuseIdentifier, for: indexPath) as! TodoTableViewCell
            cell.configureCell(todo: todo)
            cell.setupScrollViewDelegate(viewModel: viewModel, todo: todo)
            cell.setupTextFieldDelegate(viewModel: viewModel, todo: todo)
            cell.functionalButton.addAction(moveToAnotherSectionAction, for: .touchUpInside)
            availableCells.append(cell)
            return cell
        }
    }

    func updateCellsUI() {
        availableCells.forEach { cell in
            cell.updateUI()
        }
    }
    
    func applySnapshot(todos: [Todo], animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<TableViewSection, Todo>()
        snapshot.appendSections([.main])
        snapshot.appendItems(todos)
        dataSource?.apply(snapshot, animatingDifferences: animated)
        
        updateBackgroundView(isHidden: !todos.isEmpty)
    }
    
    func removeElement(todo: Todo) {
        if var snapshot = dataSource?.snapshot() {
            snapshot.deleteItems([todo])
            dataSource?.apply(snapshot, animatingDifferences: true)
        }
    }
    
    func appendTodoInSnapshot(todo: Todo) {
        if var snapshot = dataSource?.snapshot() {
            if snapshot.numberOfSections == 0 {
                snapshot.appendSections([.main])
            }
            snapshot.appendItems([todo], toSection: .main)
            dataSource?.apply(snapshot, animatingDifferences: true)

            updateBackgroundView(isHidden: !snapshot.itemIdentifiers.isEmpty)
        }
    }

    func updateBackgroundView(isHidden: Bool) {
        DispatchQueue.main.async {
            self.tableView.backgroundView?.isHidden = isHidden
        }
    }
    
    func editingTodoInSnapshot(oldTodo: Todo, newTodo: Todo) {
        if var snapshot = dataSource?.snapshot() {
            if snapshot.numberOfSections == 0 {
                snapshot.appendSections([.main])
            }
            snapshot.insertItems([newTodo], afterItem: oldTodo)
            snapshot.deleteItems([oldTodo])
            dataSource?.apply(snapshot, animatingDifferences: false)
        }
    }
}

