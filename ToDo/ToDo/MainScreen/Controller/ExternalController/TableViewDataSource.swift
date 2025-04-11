//
//  TableViewDataSource.swift
//  ToDo
//
//  Created by Тагир Файрушин on 03.02.2025.
//

import Foundation
import UIKit

class TableViewDataSource: NSObject, UITableViewDataSource {
    
    private var viewModel: MainViewModel
    
    private var soonerTableViewDataSource: TableViewDiffableDataSource?
    private var laterTableViewDataSource: TableViewDiffableDataSource?
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init()
        bingingReloadTable()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath) as! MainTableViewCell
        switch indexPath.section {
        case 0:
            soonerTableViewDataSource = TableViewDiffableDataSource(
                tableView: cell.tableView,
                viewModel: viewModel,
                section: .soon)
            soonerTableViewDataSource?.applySnapshot(todos: viewModel.todoSooner, animated: false)
        case 1:
            laterTableViewDataSource = TableViewDiffableDataSource(
                tableView: cell.tableView,
                viewModel: viewModel,
                section: .later)
            laterTableViewDataSource?.applySnapshot(todos: viewModel.todoLater, animated: false)
        default:
            print("Not found section")
        }
        
        return cell
    }
    
    func updateUI() {
        soonerTableViewDataSource?.updateCellsUI()
        laterTableViewDataSource?.updateCellsUI()
    }
    
    private func bingingReloadTable() {
        viewModel.updateSnaphot = { [weak self] action, todo, oldTodo in
            guard let self else { return }
            
            let dataSource: TableViewDiffableDataSource? = (todo.section == .soon) ? soonerTableViewDataSource : laterTableViewDataSource
            let state = (todo.section == .soon ? viewModel.todoSooner : viewModel.todoLater).isEmpty
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                dataSource?.updateBackgroundView(isHidden: !state)
            }
            
            switch action {
            case .add:
                dataSource?.appendTodoInSnapshot(todo: todo)
                
            case .remove:
                dataSource?.removeElement(todo: todo)
                
            case .editing:
                dataSource?.editingTodoInSnapshot(oldTodo: oldTodo!, newTodo: todo)
            }
        }
    }
}
