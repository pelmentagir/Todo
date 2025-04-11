//
//  ChangeColorController.swift
//  ToDo
//
//  Created by Тагир Файрушин on 22.03.2025.
//

import Foundation
import UIKit

class ChangeColorController: UIViewController {
    
    private var changeColorView: ChangeColorView {
        self.view as! ChangeColorView
    }
    
    private lazy var dismissAction = UIAction { _ in
        self.dismiss(animated: true)
    }
    
    private var collectionViewDataSource: CollectionViewDataSource?
    private var collectionViewDelegate: CollectionViewDelegate?
    
    var onDismiss: (() -> Void)?
    
    override func loadView() {
        self.view = ChangeColorView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupButton()
        setupDelegateBinding()
    }
    
    func setupCollectionView() {
        collectionViewDataSource = CollectionViewDataSource()
        collectionViewDelegate = CollectionViewDelegate()
        changeColorView.collectionView.dataSource = collectionViewDataSource
        changeColorView.collectionView.delegate = collectionViewDelegate
    }
    
    func setupButton() {
        changeColorView.dismissButton.addAction(dismissAction, for: .touchUpInside)
    }
    
    func setupDelegateBinding() {
        collectionViewDelegate?.onDismiss = { [weak self] in
            guard let self else { return }
            dismiss(animated: true)
            onDismiss?()
        }
    }
}
