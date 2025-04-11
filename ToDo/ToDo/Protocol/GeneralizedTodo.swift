//
//  GeneralizedTodo.swift
//  ToDo
//
//  Created by Тагир Файрушин on 12.03.2025.
//

import Foundation

protocol GeneralizedTodo {
    var id: UUID { get }
    var title: String { get set }
    var createdDate: Date { get }
}
