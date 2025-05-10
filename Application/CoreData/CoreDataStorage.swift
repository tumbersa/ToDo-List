//
//  CoreDataStorage.swift
//  ToDo List
//
//  Created by Глеб Капустин on 16.03.2025.
//

import CoreData
import UIKit


actor CoreDataStorage {
    private let coreDataStack: CoreDataStack

    var todoEntities: [TodoEntity] {
        get async {
            let objects: [TodoCDEntity] = await fetchObjectsFromDB(
                entity: TodoCDEntity.self,
                predicateFormat: "",
                predicateArgs: [],
                sortDescriptors: { [NSSortDescriptor(key: "title", ascending: true)] }
            )

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
    }

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    func add(entity: TodoEntity) async {
        let coreDataStack = self.coreDataStack
        let existingEntity = await fetchObjectsFromDB(
            entity: TodoCDEntity.self,
            predicateFormat: "id == %@",
            predicateArgs: [entity.id as CVarArg],
            sortDescriptors: { [] }
        ).first

        guard existingEntity == nil else { return }

        await coreDataStack.backgroundContext.perform {
            let todoCDEntity = TodoCDEntity(context: coreDataStack.backgroundContext)
            todoCDEntity.id = entity.id
            todoCDEntity.title = entity.title
            todoCDEntity.note = entity.description
            todoCDEntity.date = entity.date
            todoCDEntity.completed = entity.completed
            coreDataStack.saveChanges()
        }
    }

    func update(entity: TodoEntity) async {
        let coreDataStack = self.coreDataStack
        let existingEntity = await fetchObjectsFromDB(
            entity: TodoCDEntity.self,
            predicateFormat: "id == %@",
            predicateArgs: [entity.id as CVarArg],
            sortDescriptors: { [] }
        ).first

        await coreDataStack.backgroundContext.perform {
            if let existingEntity,
                let existingTodo = coreDataStack.backgroundContext.object(with: existingEntity.objectID) as? TodoCDEntity {
                existingTodo.title = entity.title
                existingTodo.note = entity.description
                existingTodo.date = entity.date
                existingTodo.completed = entity.completed
                coreDataStack.saveChanges()
            }
        }
    }

    func delete(entity: TodoEntity) async {
        let coreDataStack = self.coreDataStack
        let existingEntity = await fetchObjectsFromDB(
            entity: TodoCDEntity.self,
            predicateFormat: "id == %@",
            predicateArgs: [entity.id as CVarArg],
            sortDescriptors: { [] }
        ).first

        await coreDataStack.backgroundContext.perform {
            if let existingEntity {
                coreDataStack.backgroundContext.delete(
                    coreDataStack.backgroundContext.object(with: existingEntity.objectID)
                )
                coreDataStack.saveChanges()
            }
        }
    }

    func clearAllData() {
        let context = coreDataStack.viewContext
        coreDataStack.persistentContainer.managedObjectModel.entities.forEach { entity in
            guard let name = entity.name else { return }
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            deleteRequest.resultType = .resultTypeObjectIDs
            
            do {
                let result = try context.execute(deleteRequest) as? NSBatchDeleteResult
                if let objectIDs = result?.result as? [NSManagedObjectID] {
                    let changes = [NSDeletedObjectsKey: objectIDs]
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
                }
            } catch {
                print("Failed to delete entity \(name): \(error)")
            }
        }
        
        do {
            try context.save()
        } catch {
            print("Failed to save context after clearing: \(error)")
        }
    }

}

private extension CoreDataStorage {

    func fetchObjectsFromDB<T: NSManagedObject>(
        entity: T.Type,
        predicateFormat: String,
        predicateArgs: [CVarArg],
        sortDescriptors: @Sendable () -> [NSSortDescriptor]
    ) async -> [T] {
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))
        request.sortDescriptors = sortDescriptors()
        if !predicateFormat.isEmpty {
            request.predicate = NSPredicate(format: predicateFormat, argumentArray: predicateArgs)
        }
        do {
            let viewContext = coreDataStack.viewContext
            return try await viewContext.perform {
                try viewContext.fetch(request)
            }
        } catch {
#if DEBUG
            debugPrint("Core data: Error fetching. \(error)")
#endif
            return []
        }
    }
}
