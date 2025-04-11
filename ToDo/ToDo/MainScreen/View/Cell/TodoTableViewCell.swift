//
//  TodoTableViewCell.swift
//  ToDo
//
//  Created by Тагир Файрушин on 01.03.2025.
//

import UIKit

class TodoTableViewCell: UITableViewCell {
    
    private(set) var todo: GeneralizedTodo?
    private(set) var isCompletedTodo = false
    
    var onSwipeChanged: ((CGFloat, UITapGestureRecognizer.State) -> Void)?
    
    private var todoScrollHandler: TodoScrollHandler?
    private var todoTextFieldDelegate: TodoTextFieldDelegate?
    
    private var maskLayer: CAShapeLayer = CAShapeLayer()
    
    private lazy var whiteView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var completeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var grayIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "app")
        imageView.tintColor = .systemGray
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var blueIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "app")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = IconColorManager.shared.currentColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var checkmark: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = IconColorManager.shared.currentColor
        imageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(weight: .bold)
        imageView.image = UIImage(systemName: "checkmark")
        return imageView
    }()
    
    private(set) lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 16)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private(set) lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceHorizontal = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private(set) lazy var functionalButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemBackground
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var functionalImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = IconColorManager.shared.currentColor
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setupLayout()
        setupMask()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleTextField.transform = .identity
        checkmark.alpha = 0
    }
    
    func configureCell(todo: GeneralizedTodo) {
        if let todo = todo as? Todo {
            self.todo = todo
            let image = todo.section == .soon ? UIImage(systemName: "chevron.down.2") : UIImage(systemName: "chevron.up.2")
            functionalImageView.image = image
            maskLayer.strokeEnd = 0
            checkmark.alpha = 0
        } else {
            let todo = todo as! TodoEntity
            isCompletedTodo = true
            self.todo = todo
            functionalImageView.image = UIImage(systemName: "ellipsis")
            maskLayer.strokeEnd = 1
            checkmark.alpha = 1
            functionalImageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }
        
        titleTextField.text = todo.title
    }
    
    func setupScrollViewDelegate(viewModel: ViewModel, todo: GeneralizedTodo) {
        todoScrollHandler = TodoScrollHandler(viewModel: viewModel, todo: todo)
        scrollView.delegate = todoScrollHandler
        bindingUpdateUI()
    }
    
    func setupTextFieldDelegate(viewModel: MainViewModel, todo: Todo) {
        todoTextFieldDelegate = TodoTextFieldDelegate(viewModel: viewModel, todo: todo)
        titleTextField.delegate = todoTextFieldDelegate
    }
    
    func updateUI() {
        blueIconView.tintColor = IconColorManager.shared.currentColor
        checkmark.tintColor = IconColorManager.shared.currentColor
        functionalImageView.tintColor = IconColorManager.shared.currentColor
    }
    
    private func bindingUpdateUI() {
        todoScrollHandler?.animationButton = { [weak self] currentLoaded in
            guard let self else { return }
            let progress = !isCompletedTodo ? currentLoaded : 1 - currentLoaded
            
            checkmark.alpha = progress
            maskLayer.strokeEnd = progress
            
            UIView.animate(withDuration: 0.2) {
                if currentLoaded > 1 {
                    self.completeButton.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
                } else {
                    self.completeButton.transform = .identity
                    self.checkmark.transform = .identity
                }
            }
        }
    }
    
    private func setupMask() {
        let radius: CGFloat = 10
        let path = UIBezierPath(arcCenter: CGPoint(x: radius, y: radius), radius: radius, startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi * 1.5, clockwise: true)
        
        maskLayer.path = path.cgPath
        maskLayer.fillColor = UIColor.clear.cgColor
        maskLayer.strokeColor = UIColor.white.cgColor
        maskLayer.lineWidth = 15
        
        blueIconView.layer.mask = maskLayer
    }
    
    private func setupSubviews() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(whiteView)
        whiteView.addSubview(completeButton)
        whiteView.addSubview(scrollView)
        completeButton.addSubview(checkmark)
        completeButton.addSubview(grayIconView)
        completeButton.addSubview(blueIconView)
        scrollView.addSubview(titleTextField)
        whiteView.addSubview(functionalButton)
        functionalButton.addSubview(functionalImageView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            
            whiteView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            whiteView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.Constraints.small + 2),
            whiteView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.Constraints.small - 2),
            whiteView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),

            completeButton.centerYAnchor.constraint(equalTo: whiteView.centerYAnchor),
            completeButton.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: Constant.Constraints.big),
            completeButton.widthAnchor.constraint(equalTo: whiteView.heightAnchor, multiplier: 0.6  ),
            completeButton.heightAnchor.constraint(equalTo: whiteView.heightAnchor, multiplier: 0.6),
            
            grayIconView.centerXAnchor.constraint(equalTo: completeButton.centerXAnchor),
            grayIconView.centerYAnchor.constraint(equalTo: completeButton.centerYAnchor),
            grayIconView.widthAnchor.constraint(equalTo: completeButton.widthAnchor),
            grayIconView.heightAnchor.constraint(equalTo: completeButton.heightAnchor),
            
            blueIconView.centerXAnchor.constraint(equalTo: completeButton.centerXAnchor),
            blueIconView.centerYAnchor.constraint(equalTo: completeButton.centerYAnchor),
            blueIconView.widthAnchor.constraint(equalTo: completeButton.widthAnchor),
            blueIconView.heightAnchor.constraint(equalTo: completeButton.heightAnchor),

            checkmark.centerXAnchor.constraint(equalTo: completeButton.centerXAnchor),
            checkmark.centerYAnchor.constraint(equalTo: completeButton.centerYAnchor),
            checkmark.widthAnchor.constraint(equalTo: completeButton.widthAnchor, multiplier: 0.5),
            checkmark.heightAnchor.constraint(equalTo: completeButton.heightAnchor, multiplier: 0.5),

            functionalButton.centerYAnchor.constraint(equalTo: whiteView.centerYAnchor),
            functionalButton.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -Constant.Constraints.big),
            functionalButton.heightAnchor.constraint(equalTo: whiteView.heightAnchor, multiplier: 0.8),
            functionalButton.widthAnchor.constraint(equalTo: functionalButton.heightAnchor, multiplier: 0.8),
            
            functionalImageView.centerXAnchor.constraint(equalTo: functionalButton.centerXAnchor),
            functionalImageView.centerYAnchor.constraint(equalTo: functionalButton.centerYAnchor),
            functionalImageView.widthAnchor.constraint(equalTo: functionalButton.widthAnchor, multiplier: 0.55),
            functionalImageView.heightAnchor.constraint(equalTo: functionalButton.heightAnchor, multiplier: 0.55),

            scrollView.topAnchor.constraint(equalTo: whiteView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: completeButton.trailingAnchor, constant: Constant.Constraints.medium),
            scrollView.trailingAnchor.constraint(equalTo: functionalButton.leadingAnchor, constant: -Constant.Constraints.big),
            scrollView.bottomAnchor.constraint(equalTo: whiteView.bottomAnchor),

            titleTextField.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            titleTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            titleTextField.trailingAnchor.constraint(equalTo: functionalButton.leadingAnchor, constant: -Constant.Constraints.big)
        ])
    }}

extension TodoTableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
