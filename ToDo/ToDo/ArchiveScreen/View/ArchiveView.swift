//
//  ArchiveView.swift
//  ToDo
//
//  Created by Тагир Файрушин on 12.03.2025.
//

import UIKit
import SwiftUI

class ArchiveView: UIView {
    private var viewModel: ArchiveViewModel
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .secondarySystemBackground
        tableView.rowHeight = 48
        tableView.layer.cornerRadius = 16
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentInset = UIEdgeInsets.init(top: 5, left: 0, bottom: 5, right: 0)
        tableView.isScrollEnabled = false
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: TodoTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    private lazy var todoCharts: UIHostingController<TodoCharts> = {
        let hC = UIHostingController(rootView: TodoCharts(archiveViewModel: viewModel))
        hC.view.translatesAutoresizingMaskIntoConstraints = false
        return hC
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [todoCharts.view, tableView])
        stackView.axis = .vertical
        stackView.spacing = Constant.Constraints.big
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var heightTableView: CGFloat {
        return CGFloat(48 * (viewModel.getCountAllObjects()) + 10)
    }
    
    private var tableViewHeightConstraint: NSLayoutConstraint!
    
    init(viewModel: ArchiveViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        setupSubviews()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateHeigth() {
        self.tableViewHeightConstraint.constant = self.heightTableView
    }
    
    private func setupSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(stackView)
    }
    
    private func setupLayout() {
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: heightTableView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constant.Constraints.big),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constant.Constraints.big),
            scrollView.widthAnchor.constraint(equalTo: widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.95),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            tableViewHeightConstraint
        ])
    }
}
