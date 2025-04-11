//
//  Todo.swift
//  ToDo
//
//  Created by Тагир Файрушин on 01.03.2025.
//

import Foundation

struct Todo: Hashable, GeneralizedTodo {
    var id = UUID()
    var title: String
    var section: HeaderType = .soon
    var createdDate = Date()
    
    init(id: UUID = UUID() ,title: String, section: HeaderType, creationData: Date = Date()) {
        self.id = id
        self.title = title
        self.section = section
        self.createdDate = creationData
    }
    
    mutating func renameTitle(newText: String) {
        self.title = newText
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}
