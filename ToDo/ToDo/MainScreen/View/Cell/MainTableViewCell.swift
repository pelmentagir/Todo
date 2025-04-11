//
//  MainTableViewCell.swift
//  ToDo
//
//  Created by Тагир Файрушин on 03.02.2025.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        let label = UILabel()
        label.text = "Nothing to do, nice"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        tableView.backgroundView = label
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .secondarySystemBackground
        tableView.layer.cornerRadius = 16
        tableView.separatorStyle = .none
        tableView.rowHeight = 48
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: TodoTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(tableView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: contentView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.Constraints.small),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.Constraints.small),
            tableView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
}

extension MainTableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
