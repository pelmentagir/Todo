//
//  CustomHeightPresentationController.swift
//  ToDo
//
//  Created by Тагир Файрушин on 15.03.2025.
//

import UIKit

class CustomHeightPresentationController: UIPresentationController {
    
    private let customHeight: CGFloat
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.35)
        return view
    }()
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, customHeigth: CGFloat) {
        self.customHeight = customHeigth
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView else { return .zero }
        
        let height = min(customHeight, containerView.bounds.height)
        return CGRect(x: 0,
                      y: containerView.bounds.height - height,
                      width: containerView.bounds.width,
                      height: height)
    }
    
    override func presentationTransitionWillBegin() {
        setup()
        backgroundView.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 1
        }
    }
    
    override func dismissalTransitionWillBegin() {
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 0
        } completion: { _ in
            self.backgroundView.removeFromSuperview()
        }
    }
}

private extension CustomHeightPresentationController {
    
    func setup() {
        setupSubviews()
        setupLayout()
    }
    
    func setupSubviews() {
        containerView?.addSubview(backgroundView)
    }
    
    func setupLayout() {
        guard let containerView = containerView else { return }
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: containerView.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }
}
