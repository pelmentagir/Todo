//
//  CollectionViewDataSource.swift
//  ToDo
//
//  Created by Тагир Файрушин on 22.03.2025.
//

import Foundation
import UIKit

class CollectionViewDataSource: NSObject, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        IconColor.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifier, for: indexPath) as! CollectionViewCell
        cell.setupColor(color: IconColor.color(for: indexPath.item), isSelected: IconColor.color(for: indexPath.item) == IconColorManager.shared.currentColor)
        return cell
    }
    
}
