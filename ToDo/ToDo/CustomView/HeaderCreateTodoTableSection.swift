//
//  HeaderTextFieldTableSection.swift
//  ToDo
//
//  Created by Тагир Файрушин on 27.02.2025.
//

import UIKit

class HeaderCreateTodoTableSection: UIView {
    
    lazy var iconImage: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "lightbulb.fill"))
        image.contentMode = .scaleAspectFit
        image.tintColor = .systemYellow
        image.clipsToBounds = true
        image.alpha = 0.25
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.clearButtonMode = .whileEditing
        textField.placeholder = "Add a todo"
        textField.leftViewMode = .always
        textField.font = .boldSystemFont(ofSize: 16)
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupSubviews()
        setupLayout()
    }
    
    override func didMoveToSuperview() {
        textField.becomeFirstResponder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTextFieldDelegate(_ delegate: UITextFieldDelegate) {
        textField.delegate = delegate
    }
    
    private func setupSubviews() {
        addSubview(iconImage)
        addSubview(textField)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            iconImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.Constraints.large),
            iconImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImage.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.45),
            iconImage.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.45),
            
            textField.leadingAnchor.constraint(equalTo: iconImage.trailingAnchor, constant: Constant.Constraints.medium),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constant.Constraints.large),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
}
