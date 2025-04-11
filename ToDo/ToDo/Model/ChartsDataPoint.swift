//
//  ChartsDataPoint.swift
//  ToDo
//
//  Created by Тагир Файрушин on 17.03.2025.
//

import Foundation

struct ChartsDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
}
