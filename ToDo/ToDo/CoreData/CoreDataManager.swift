//
//  CoreDataManager.swift
//  ToDo
//
//  Created by Тагир Файрушин on 01.03.2025.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static var shared: CoreDataManager = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "ToDo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var viewContext: NSManagedObjectContext = {
        let context = persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    private init() {}
    
    func saveCompletedTodo(todo: Todo) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            do {
                let fetchRequest = TodoEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", todo.id.uuidString)
                
                let results = try backgroundContext.fetch(fetchRequest)
                
                let entity: TodoEntity
                if let existingEntity = results.first {
                    entity = existingEntity
                } else {
                    entity = TodoEntity(context: backgroundContext)
                }
                
                entity.merge(todo: todo)
                entity.finishedDate = Date()
                
                try backgroundContext.save()
            } catch {
                print("Error save completed todo: \(error)")
            }
        }
    }
    
    func createFetchResultController() -> NSFetchedResultsController<TodoEntity> {
        let fetchRequest = TodoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "finishedDate != nil")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "finishedDate", ascending: false)]
        
        let fetchResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchResultController
    }
    
    func obtainTodos() -> (sooner: [Todo], later: [Todo]) {
        let fetchRequest = TodoEntity.fetchRequest()
        
        do {
            let result = try viewContext.fetch(fetchRequest)
            var soonerTodos: [Todo] = []
            var laterTodos: [Todo] = []
            
            for entity in result  {
                if entity.finishedDate == nil {
                    
                    let todo = Todo(id: entity.id,
                                    title: entity.title,
                                    section: entity.section == "soon" ? .soon : .later,
                                    creationData: entity.createdDate)
                    
                    switch todo.section {
                    case .soon: soonerTodos.append(todo)
                    case .later: laterTodos.append(todo)
                    }
                    
                }
            }
            return (sooner: soonerTodos, later: laterTodos)
        } catch {
            print("Fetch error: \(error.localizedDescription)")
            return (sooner: [], later: [])
        }
    }
    
    func deleteTodo(todo: TodoEntity) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            do {
                if let objectToDelete = try backgroundContext.existingObject(with: todo.objectID) as? TodoEntity {
                    backgroundContext.delete(objectToDelete)
                    try backgroundContext.save()
                }
            } catch {
                print("Delete error: \(error.localizedDescription)")
            }
        }
    }

    func saveTodos(soonerTodos: [Todo], laterTodos: [Todo]) {
        let fetchRequest = TodoEntity.fetchRequest()
        do {
            let results = try viewContext.fetch(fetchRequest)
            let dictionaryTodos = Dictionary(uniqueKeysWithValues: results.map { ($0.id, $0) })
            
            var processedIds: Set<UUID> = []
            
            for todo in soonerTodos {
                if let entity = dictionaryTodos[todo.id] {
                    
                    if entity.section != "soon" {
                        entity.section = "soon"
                    }
                    
                    if entity.title != todo.title {
                        entity.title = todo.title
                    }
                    
                } else {
                    let newTodo = TodoEntity(context: viewContext)
                    newTodo.merge(todo: todo)
                }
                processedIds.insert(todo.id)
            }
            
            for todo in laterTodos {
                if let entity = dictionaryTodos[todo.id] {
                    
                    if entity.section != "later" {
                        entity.section = "later"
                    }
                    
                    if entity.title != todo.title {
                        entity.title = todo.title
                    }
                    
                } else {
                    let newTodo = TodoEntity(context: viewContext)
                    newTodo.merge(todo: todo)
                }
                
                processedIds.insert(todo.id)
            }
            
            for (id, entity) in dictionaryTodos where !processedIds.contains(id) {
                if entity.finishedDate == nil {
                    viewContext.delete(entity)
                }
            }
            
            try viewContext.save()
        } catch {
            print("Error save context")
        }
        
    }
}
