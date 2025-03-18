//
//  TodoStore.swift
//  ToDo List
//
//  Created by Глеб Капустин on 16.03.2025.
//

import CoreData
import UIKit

protocol IStore {
    associatedtype Entity
    var entities: [Entity] { get }
    func addEntity(_ entity: Entity)
    func updateEntity(_ entity: Entity)
}

final class TodoStore: IStore {
    typealias Entity = TodoEntity

    private let context: NSManagedObjectContext

    var entities: [TodoEntity] {
        let request = TodoCDEntity.fetchRequest()
        let objects: [TodoCDEntity] = (try? context.fetch(request)) ?? []
        var todo: [TodoEntity] = []
        objects.forEach { object in
            if let id = object.id, let title = object.title, let note = object.note, let date = object.date {
                todo.append(.init(
                    id: id,
                    title: title,
                    description: note,
                    date: date,
                    completed: object.completed
                ))
            }
        }
        return todo
    }

    init() {
        self.context = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
    }

    func addEntity(_ todo: TodoEntity) {
        let todoCDEntity = TodoCDEntity(context: context)
        todoCDEntity.id = todo.id
        todoCDEntity.title = todo.title
        todoCDEntity.note = todo.description
        todoCDEntity.date = todo.date
        todoCDEntity.completed = todo.completed
        saveContext()
    }

    func updateEntity(_ todo: TodoEntity) {
        let request = TodoCDEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", todo.id as CVarArg)

        do {
            let results = try context.fetch(request)
            if let existingTodo = results.first {
                existingTodo.title = todo.title
                existingTodo.note = todo.description
                existingTodo.date = todo.date
                existingTodo.completed = todo.completed
                saveContext()
            }
        } catch {
            debugPrint("Failed to update entity: \(error)")
        }
    }

}

private extension TodoStore {

    func saveContext() {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }

}
