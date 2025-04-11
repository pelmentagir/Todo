//
//  TableViewFetchDataSource.swift
//  ToDo
//
//  Created by Тагир Файрушин on 12.03.2025.
//

import UIKit

class TableViewFetchDataSource: NSObject, UITableViewDataSource {
    
    private var viewModel: ArchiveViewModel
    var presentDetailView: ((TodoEntity) -> Void)?
    
    private lazy var showMiniDetailViewAction = UIAction { [weak self] event in
        guard let self else { return }
        if let button = event.sender as? UIButton, let cell = button.superview?.superview?.superview as? TodoTableViewCell {
            presentDetailView?(cell.todo as! TodoEntity)
        }
    }
    
    init(viewModel: ArchiveViewModel) {
        self.viewModel = viewModel
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getNumberOfElementsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableViewCell.reuseIdentifier, for: indexPath) as! TodoTableViewCell
        let todo = viewModel.getTodo(indexPath: indexPath)
        cell.configureCell(todo: todo)
        cell.functionalButton.addAction(showMiniDetailViewAction, for: .touchUpInside)
        cell.setupScrollViewDelegate(viewModel: viewModel, todo: todo)
        return cell
    }
}
