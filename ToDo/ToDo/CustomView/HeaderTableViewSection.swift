//
//  HeaderTableViewSectionSoon.swift
//  ToDo
//
//  Created by Тагир Файрушин on 03.02.2025.
//

import Foundation
import UIKit

class HeaderTableViewSection: UIView, UIScrollViewDelegate {
    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = .systemBackground
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .systemBackground
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private lazy var iconSection: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "note"))
        image.tintColor = IconColorManager.shared.currentColor
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.text = "Soon"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var counterTask: CounterTaskView = {
        let counterTask = CounterTaskView()
        counterTask.backgroundColor = .secondarySystemBackground
        counterTask.layer.cornerRadius = 12
        counterTask.translatesAutoresizingMaskIntoConstraints = false
        return counterTask
    }()
    
    lazy var rectangleButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "rectangle.expand.vertical"), for: .normal)
        button.tintColor = IconColorManager.shared.currentColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(iconImage: UIImage, title: String) {
        super.init(frame: .zero)
        self.iconSection.image = iconImage
        self.title.text = title
        scrollView.delegate = self
        switch title {
        case "Soon":
            rectangleButton.tag = 1
        case "Later":
            rectangleButton.tag = 2
        default:
            print("Not found tag")
        }
        
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateColor() {
        iconSection.tintColor = IconColorManager.shared.currentColor
        rectangleButton.tintColor = IconColorManager.shared.currentColor
    }
    
    private func setupViews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(iconSection)
        contentView.addSubview(title)
        contentView.addSubview(rectangleButton)
        contentView.addSubview(counterTask)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: Constant.TableViewSize.headerHeight),
            
            iconSection.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.Constraints.large),
            
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            title.leadingAnchor.constraint(equalTo: iconSection.trailingAnchor, constant: Constant.Constraints.medium),
            
            rectangleButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rectangleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.Constraints.large),
            
            counterTask.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            counterTask.trailingAnchor.constraint(equalTo: rectangleButton.leadingAnchor, constant: -Constant.Constraints.medium),
            counterTask.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.065),
            counterTask.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.065),
        ])
    }
}
