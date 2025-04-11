//
//  CollectionViewDelegate.swift
//  ToDo
//
//  Created by Тагир Файрушин on 23.03.2025.
//

import Foundation
import UIKit

class CollectionViewDelegate: NSObject, UICollectionViewDelegate {
    var onDismiss: (() -> Void)?
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let color = IconColor.color(for: indexPath.item)
        IconColorManager.shared.currentColor = color
        collectionView.reloadData()
        onDismiss?()
    }
}
