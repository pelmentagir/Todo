//
//  MainViewController.swift
//  ToDo
//
//  Created by Тагир Файрушин on 03.02.2025.
//

import UIKit
import SPLarkController

class MainViewController: UIViewController, KeyboardObservable {
    var keyboardObserver: KeyboardObserver?
    
    private var mainView: MainView {
        self.view as! MainView
    }
    
    private var viewModel: MainViewModel
    
    private var tableViewDataSource: TableViewDataSource?
    private var tableViewDelegate: TableViewDelegate?
    private var coreDataManager = CoreDataManager.shared
    
    private lazy var expandOrCollapseAction = UIAction { [weak self] event in
        guard let self = self else { return }
        if let button = event.sender as? UIButton, let tableViewDelegate = tableViewDelegate {
            viewModel.expandOrCollapseAction(selectedHeader: HeaderType(rawValue: button.tag)!)
        }
    }
    
    private lazy var showOrHideTodoHeaderAction = UIAction { [weak self] _ in
        guard let self = self else { return }
        viewModel.changeKeyboardState()
    }
    
    private lazy var pushArchiveView = UIAction { [weak self] _ in
        guard let self else { return }
        let archiveViewController = ArchiveViewController(viewModel: ArchiveViewModel())
        archiveViewController.restoringTodo = { [weak self] todo in
            guard let self else { return }
            viewModel.appendTodoBySection(todo, section: todo.section)
        }
        present(archiveViewController, animated: true)
    }
    
    private lazy var pushSettingsView = UIAction { [weak self] _ in
        guard let self else { return }
        let settingView = SettingsController()
        let transitionDelegate = SPLarkTransitioningDelegate()
        transitionDelegate.customHeight = UIScreen.main.bounds.height / 5
        settingView.transitioningDelegate = transitionDelegate
        settingView.modalPresentationStyle = .custom
        present(settingView, animated: true)
    }
    
    override func loadView() {
        self.view = MainView()
    }
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        bindingHeightAndButton()
        headerGestureAction()
        setupKeyboardObserver()
        setupActionsToolBar()
        bindingChangeHeader()
        bindingUpdateHeight()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.counterTask?(viewModel.todoSooner.count, .soon)
        viewModel.counterTask?(viewModel.todoLater.count, .later)
        setupObserver()
    }
    
    private func headerGestureAction() {
        guard let tableViewDelegate = tableViewDelegate else { return }
        tableViewDelegate.headerGesture = { [weak self] isState in
            guard let self = self else { return }
            viewModel.headerGesture(state: isState)
        }
    }
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: .iconColorChange, object: nil)
    }
    
    @objc private func updateUI() {
        tableViewDelegate?.updateColor()
        mainView.addItemToolbar.tintColor = IconColorManager.shared.currentColor
        mainView.archiveItemToolBar.tintColor = IconColorManager.shared.currentColor
        mainView.gearItemToolbar.tintColor = IconColorManager.shared.currentColor
        tableViewDataSource?.updateUI()
    }
    
    private func setupKeyboardObserver() {
        keyboardObserver = KeyboardObserver(onShow: { [weak self] keyboardFrame in
            guard let self else { return }
            mainView.updateHeight(newHeight: keyboardFrame.height)
        }, onHide: { [weak self] in
            guard let self else { return }
            mainView.endEditing(true)
            mainView.updateHeight(newHeight: Constant.UIInsets.bottomInset)
        })
    }
    
    private func setupActionsToolBar() {
        setupActionAddBarButtonItem()
        setupActionArchiveBarButtonItem()
        setupActionSettingsBarButtonItem()
    }
    
    private func setupActionAddBarButtonItem() {
        mainView.addItemToolbar.primaryAction = showOrHideTodoHeaderAction
        mainView.addItemToolbar.image = UIImage(systemName: "plus")
        mainView.addItemToolbar.tintColor = IconColorManager.shared.currentColor
    }
    
    private func setupActionArchiveBarButtonItem() {
        mainView.archiveItemToolBar.primaryAction = pushArchiveView
        mainView.archiveItemToolBar.image = UIImage(systemName: "archivebox")
        mainView.archiveItemToolBar.tintColor = IconColorManager.shared.currentColor
    }
    
    private func setupActionSettingsBarButtonItem() {
        mainView.gearItemToolbar.primaryAction = pushSettingsView
        mainView.gearItemToolbar.image = UIImage(systemName: "gear")
        mainView.gearItemToolbar.tintColor = IconColorManager.shared.currentColor
    }
    
    private func bindingHeightAndButton() {
        viewModel.onHeightAndButtonUpdate = { [weak self] selectedHeader, height1, height2 in
            guard let self else { return }
            self.updateTable()
            self.tableViewDelegate?.animateButton(selectedHeader, soonerHeight: height1, laterHeight: height2)
        }
    }
    
    private func bindingUpdateHeight() {
        viewModel.updateHeightCell = { [weak self] in
            guard let self else { return }
            updateTable()
        }
    }
    
    private func bindingChangeHeader() {
        viewModel.changeHeader = { [weak self] in
            guard let self else { return }
            mainView.endEditing(true)
            updateTable()
            mainView.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        }
    }
    
    private func updateTable() {
        mainView.tableView.beginUpdates()
        mainView.tableView.endUpdates()
    }
    
    private func configureTableView() {
        tableViewDataSource = TableViewDataSource(viewModel: viewModel)
        tableViewDelegate = TableViewDelegate(viewModel: viewModel)
        mainView.tableView.dataSource = tableViewDataSource
        mainView.tableView.delegate = tableViewDelegate
        tableViewDelegate?.sooner.rectangleButton.addAction(expandOrCollapseAction, for: .touchUpInside)
        tableViewDelegate?.later.rectangleButton.addAction(expandOrCollapseAction, for: .touchUpInside)
    }
}
