//
//  HeaderType.swift
//  ToDo
//
//  Created by Тагир Файрушин on 08.02.2025.
//

import Foundation

enum HeaderType: Int {
    case soon = 1
    case later
    
    var getValue: String {
        switch self {
        case .soon: return "soon"
        case .later: return "later"
        }
    }
}
