//
//  CustomAlert.swift
//  ToDo
//
//  Created by Тагир Файрушин on 14.03.2025.
//

import UIKit

class CustomMiniDetailView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var createdLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray
        label.text = "Created"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var completedLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray
        label.text = "Completed"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var createdDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var completedDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var createdTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var completedTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var timeDifferenceLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold), forImageIn: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private(set) lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 12
        button.setTitle("Delete Todo", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var customView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 24
        return view
    }()
    
    private lazy var meanStackView: UIStackView = {
        let stackView1 = createStackView(arrangedSubviews: [createdLabel, completedLabel],
                                         axis: .horizontal,
                                         distribution: .equalSpacing)
        let stackView2 = createStackView(arrangedSubviews: [createdDateLabel, timeDifferenceLabel, completedDateLabel],
                                         axis: .horizontal,
                                         distribution: .equalSpacing)
        let stackView3 = createStackView(arrangedSubviews: [createdTimeLabel, completedTimeLabel],
                                         axis: .horizontal,
                                         distribution: .equalSpacing)
        let stackView = UIStackView(arrangedSubviews: [stackView1, stackView2, stackView3])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Constant.Constraints.medium
        return stackView
    }()
    
    private lazy var globalStackView: UIStackView = {
        let topStackView = createStackView(arrangedSubviews: [titleLabel, dismissButton],
                                           axis: .horizontal,
                                           distribution: .equalSpacing)
        let stackView = UIStackView(arrangedSubviews: [topStackView, meanStackView, deleteButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Constant.Constraints.large
        return stackView
    }()
    
    private lazy var rightSeporator: UIView = {
        let seporator = UIView()
        seporator.translatesAutoresizingMaskIntoConstraints = false
        seporator.backgroundColor = .systemGray2
        return seporator
    }()
    
    private lazy var leftSeporator: UIView = {
        let seporator = UIView()
        seporator.translatesAutoresizingMaskIntoConstraints = false
        seporator.backgroundColor = .systemGray2
        return seporator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .clear
    
        setupSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(title: String,
                       createdDate: String,
                       completedDate: String,
                       timeDifference: String,
                       createdTime: String,
                       completedTime: String) {
        titleLabel.text = title
        createdDateLabel.text = createdDate
        completedDateLabel.text = completedDate
        timeDifferenceLabel.text = timeDifference
        createdTimeLabel.text = createdTime
        completedTimeLabel.text = completedTime
    }
    
    private func setupSubviews() {
        addSubview(customView)
        customView.addSubview(globalStackView)
        globalStackView.addSubview(rightSeporator)
        globalStackView.addSubview(leftSeporator)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: topAnchor, constant: Constant.Constraints.big),
            customView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.Constraints.medium),
            customView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constant.Constraints.medium),
            customView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Constant.Constraints.big),

            globalStackView.topAnchor.constraint(equalTo: customView.topAnchor, constant: Constant.Constraints.xlarge),
            globalStackView.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: Constant.Constraints.xlarge),
            globalStackView.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -Constant.Constraints.xlarge),
            globalStackView.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -Constant.Constraints.xlarge),
    
            rightSeporator.centerYAnchor.constraint(equalTo: meanStackView.centerYAnchor),
            rightSeporator.leadingAnchor.constraint(equalTo: createdDateLabel.trailingAnchor, constant: Constant.Constraints.medium),
            rightSeporator.trailingAnchor.constraint(equalTo: timeDifferenceLabel.leadingAnchor, constant: -Constant.Constraints.medium),
            rightSeporator.heightAnchor.constraint(equalToConstant: 0.5),
            
            leftSeporator.centerYAnchor.constraint(equalTo: meanStackView.centerYAnchor),
            leftSeporator.leadingAnchor.constraint(equalTo: timeDifferenceLabel.trailingAnchor, constant: Constant.Constraints.medium),
            leftSeporator.trailingAnchor.constraint(equalTo: completedDateLabel.leadingAnchor, constant: -Constant.Constraints.medium),
            leftSeporator.heightAnchor.constraint(equalToConstant: 0.5),

            deleteButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    private func createStackView(arrangedSubviews: [UIView],
                                 axis: NSLayoutConstraint.Axis,
                                 distribution: UIStackView.Distribution) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = axis
        stackView.distribution = distribution
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
}
