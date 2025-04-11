//
//  MainView.swift
//  ToDo
//
//  Created by Тагир Файрушин on 03.02.2025.
//

import UIKit

class MainView: UIView {

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.sectionHeaderTopPadding = 0
        tableView.separatorStyle = .none
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    private lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.barTintColor = .systemBackground
        toolbar.isTranslucent = false
        toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        let space = UIBarButtonItem(systemItem: .flexibleSpace)
        toolbar.items = [gearItemToolbar, space, addItemToolbar, space, archiveItemToolBar]
        return toolbar
    }()
    
    lazy var gearItemToolbar: UIBarButtonItem = {
        UIBarButtonItem()
    }()
    
    lazy var addItemToolbar: UIBarButtonItem = {
        UIBarButtonItem()
    }()

    lazy var archiveItemToolBar: UIBarButtonItem = {
        UIBarButtonItem()
    }()
    
    private var toolbarBottomAnchor: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        layer.cornerRadius = 24
        layer.masksToBounds = true
        setupView()
        setupLayout()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(tableView)
        addSubview(toolbar)
    }
    
    func updateHeight(newHeight: CGFloat) {
        UIView.animate(withDuration: 0.25) {
            self.toolbarBottomAnchor.constant = -newHeight + Constant.UIInsets.bottomInset
            self.layoutIfNeeded()
            self.changeBarButtonItem()
        }
    }
    
    func changeBarButtonItem() {
        if toolbarBottomAnchor.constant < 0 {
            toolbar.items?[2].image = UIImage(systemName: "keyboard.chevron.compact.down")
        } else {
            toolbar.items?[2].image = UIImage(systemName: "plus")
        }
    }
    
    private func setupLayout() {
        toolbarBottomAnchor = toolbar.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: toolbar.topAnchor),
            
            toolbar.leadingAnchor.constraint(equalTo: leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: trailingAnchor),
            toolbarBottomAnchor,
        ])
    }
}
