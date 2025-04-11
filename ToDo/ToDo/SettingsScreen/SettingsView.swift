//
//  SettingsView.swift
//  ToDo
//
//  Created by Тагир Файрушин on 21.03.2025.
//

import UIKit

class SettingsView: UIView {
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = .systemBackground
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var colorSchemeButton: UIButton = {
        createSettingButton(title: "Color Scheme", icon: UIImage(systemName: "sun.horizon")!)
    }()
    
    private(set) lazy var accentColorButton: UIButton = {
        createSettingButton(title: "Accent Color", icon: UIImage(systemName: "paintbrush")!)
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [colorSchemeButton, accentColorButton])
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .label
        setupSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(headerLabel)
        addSubview(buttonsStackView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constant.Constraints.big),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.Constraints.big),
            
            buttonsStackView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: Constant.Constraints.large),
            buttonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.Constraints.big)
        ])
    }
    
    private func createSettingButton(title: String, icon: UIImage) -> UIButton {
        let settingsButton = SettingsButton()
        settingsButton.configureButton(title: title, image: icon)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingsButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.2),
            settingsButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.35)
        ])
        return settingsButton
    }
}


