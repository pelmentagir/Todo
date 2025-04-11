//
//  CustomMiniDetailViewController.swift
//  ToDo
//
//  Created by Тагир Файрушин on 14.03.2025.
//

import UIKit

class CustomMiniDetailViewController: UIViewController {
    
    private var detailView: CustomMiniDetailView {
        self.view as! CustomMiniDetailView
    }
    
    private var todoEntity: TodoEntity
    private var viewModel: ArchiveViewModel
    
    private lazy var dismissAction = UIAction { _ in
        self.dismiss(animated: true)
    }
    
    private lazy var deleteAction = UIAction { [weak self] _ in
        guard let self else { return }
        viewModel.deleteTodoFromCoreData(entity: todoEntity)
        dismiss(animated: true)
    }
    
    override func loadView() {
        self.view = CustomMiniDetailView()
    }
    
    init(todo: TodoEntity, viewModel: ArchiveViewModel) {
        self.todoEntity = todo
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupView() {
        detailView.configureView(title: todoEntity.title,
                                 createdDate: viewModel.formatDate(todoEntity.createdDate),
                                 completedDate: viewModel.formatDate(todoEntity.finishedDate!),
                                 timeDifference: viewModel.timeDifference(from: todoEntity.createdDate, to: todoEntity.finishedDate!),
                                 createdTime: viewModel.formatTime(todoEntity.createdDate),
                                 completedTime: viewModel.formatTime(todoEntity.finishedDate!))
        detailView.dismissButton.addAction(dismissAction, for: .touchUpInside)
        detailView.deleteButton.addAction(deleteAction, for: .touchUpInside)
    }
}
