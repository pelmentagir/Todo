//
//  Extencient.swift
//  ToDo
//
//  Created by Тагир Файрушин on 18.03.2025.
//

import Foundation

extension Calendar {
    func startOfWeek(for date: Date) -> Date? {
        let components = self.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return self.date(from: components)
    }
}
