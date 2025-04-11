//
//  IconColors.swift
//  ToDo
//
//  Created by Тагир Файрушин on 22.03.2025.
//

import Foundation
import UIKit

enum IconColor: CaseIterable {
    case defaultColor
    case red
    case orange
    case yellow
    case green
    case blue
    case pink
    case purple
    
    var color: UIColor {
        switch self {
        case .defaultColor: return .label
        case .red: return .systemRed
        case .orange: return .systemOrange
        case .yellow: return .systemYellow
        case .green: return .systemGreen
        case .blue: return .systemBlue
        case .pink: return .systemPink
        case .purple: return .systemPurple
        }
    }
    
    static func color(for number: Int) -> UIColor {
        let colors = IconColor.allCases
        let index = number % colors.count
        return colors[index].color
    }
}
