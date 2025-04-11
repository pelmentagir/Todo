//
//  CollectionViewCell.swift
//  ToDo
//
//  Created by Тагир Файрушин on 22.03.2025.
//

import Foundation
import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    private lazy var circleImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "circle.fill"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupColor(color: UIColor, isSelected: Bool) {
        circleImage.image = !isSelected ? UIImage(systemName: "circle.fill") : UIImage(systemName: "circle.circle.fill")
        circleImage.tintColor = color
    }
    
    private func setupSubviews() {
        contentView.addSubview(circleImage)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            circleImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            circleImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            circleImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            circleImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

extension CollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
