//
//  TodoEntity+CoreDataClass.swift
//  ToDo
//
//  Created by Тагир Файрушин on 01.03.2025.
//
//

import Foundation
import CoreData

@objc(TodoEntity)
public class TodoEntity: NSManagedObject, GeneralizedTodo {

}

extension TodoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoEntity> {
        return NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
    }

    @NSManaged public var createdDate: Date
    @NSManaged public var finishedDate: Date?
    @NSManaged public var id: UUID
    @NSManaged public var section: String
    @NSManaged public var title: String

}

extension TodoEntity : Identifiable {
    func merge(todo: Todo) {
        self.id = todo.id
        self.title = todo.title
        self.section = todo.section.getValue
        self.createdDate = todo.createdDate
    }
}
