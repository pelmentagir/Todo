//
//  CounterTaskView.swift
//  ToDo
//
//  Created by Тагир Файрушин on 08.02.2025.
//

import UIKit

class CounterTaskView: UIView {
    
    private lazy var counterTask: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCount(_ count: String) {
        counterTask.text = count
    }
    
    private func setupLayout() {
        addSubview(counterTask)
        NSLayoutConstraint.activate([
            counterTask.centerXAnchor.constraint(equalTo: centerXAnchor),
            counterTask.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
