//
//  ChangeColorView.swift
//  ToDo
//
//  Created by Тагир Файрушин on 22.03.2025.
//

import Foundation
import UIKit

class ChangeColorView: UIView {
    
    private lazy var customView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 24
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .label
        label.text = "Accent Color"
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
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16)
        label.text = "Choose a color that matches your style!"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 35, height: 35)
        layout.minimumInteritemSpacing = Constant.Constraints.small
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, dismissButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [topStackView, infoLabel, collectionView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Constant.Constraints.big
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(customView)
        customView.addSubview(mainStackView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: topAnchor, constant: Constant.Constraints.big),
            customView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.Constraints.medium),
            customView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constant.Constraints.medium),
            customView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Constant.Constraints.big),

            mainStackView.topAnchor.constraint(equalTo: customView.topAnchor, constant: Constant.Constraints.xlarge),
            mainStackView.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: Constant.Constraints.xlarge),
            mainStackView.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -Constant.Constraints.xlarge),
            mainStackView.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -Constant.Constraints.xlarge),
        ])
    }
}
