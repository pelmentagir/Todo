//
//  SettingsButton.swift
//  ToDo
//
//  Created by Тагир Файрушин on 25.03.2025.
//

import Foundation
import UIKit

class SettingsButton: UIButton {
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [customImage, customTitle])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.isUserInteractionEnabled = false
        stackView.alignment = .center
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var customImage: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var customTitle: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBlue
        layer.cornerRadius = 16
        setupSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureButton(title: String, image: UIImage) {
        self.customTitle.text = title
        self.customImage.image = image
    }
    
    func setupSubviews() {
        addSubview(stackView)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}


