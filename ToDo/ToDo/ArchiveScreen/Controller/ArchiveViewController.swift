//
//  ArchiveViewController.swift
//  ToDo
//
//  Created by Тагир Файрушин on 12.03.2025.
//

import UIKit

class ArchiveViewController: UIViewController {

    private var archiveView: ArchiveView {
        self.view as! ArchiveView
    }
    
    private var viewModel: ArchiveViewModel
    private var tableViewDataSource: TableViewFetchDataSource?
    var restoringTodo: ((Todo) -> Void)?
    
    init(viewModel: ArchiveViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = ArchiveView(viewModel: viewModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableViewDataSource()
        bindingUpdateTableView()
        bindingShowMiniDetailView()
    }
    
    private func configureTableViewDataSource() {
        tableViewDataSource = TableViewFetchDataSource(viewModel: viewModel)
        archiveView.tableView.dataSource = tableViewDataSource
    }
    
    private func bindingShowMiniDetailView() {
        tableViewDataSource?.presentDetailView = { [weak self] todo in
            guard let self else { return }
            let miniDetailView = CustomMiniDetailViewController(todo: todo, viewModel: viewModel)
            miniDetailView.modalPresentationStyle = .custom
            miniDetailView.modalTransitionStyle = .coverVertical
            miniDetailView.transitioningDelegate = self
            present(miniDetailView, animated: true)
        }
    }
    
    private func bindingUpdateTableView() {
        viewModel.beginUpdateTableView = { [weak self] in
            guard let self else { return }
            archiveView.tableView.beginUpdates()
        }
        
        viewModel.endUpdateTableView = { [weak self] in
            guard let self else { return }
            archiveView.tableView.endUpdates()
        }
        
        viewModel.deleteRowAt = { [weak self] indexPath in
            guard let self else { return }
            archiveView.tableView.deleteRows(at: [indexPath], with: .fade)
            archiveView.updateHeigth()
        }
        
        viewModel.insertRowAt = { [weak self] indexPath in
            guard let self else { return }
            archiveView.tableView.insertRows(at: [indexPath], with: .fade)
        }
        
        viewModel.restoreTodo = { [weak self] todoEnitity in
            guard let self else { return }
            let todo = Todo(id: todoEnitity.id, title: todoEnitity.title, section: todoEnitity.section == "soon" ? .soon : .later, creationData: todoEnitity.createdDate)
            restoringTodo?(todo)
        }
    }
    
    
}

extension ArchiveViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomHeightPresentationController(presentedViewController: presented, presenting: presenting, customHeigth: UIScreen.main.bounds.height * 0.33)
    }
}
