//
//  CoreDataStack.swift
//  ToDo List
//
//  Created by Глеб Капустин on 10.05.2025.
//

import CoreData
import Combine
import UIKit

final class CoreDataStack {

    static let shared = CoreDataStack()

    private var cancellables: Set<AnyCancellable> = []

    private(set) lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDo_List")
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
#if DEBUG
                debugPrint("Unresolved error \(error), \(error.userInfo)")
#endif
            }
        }
        return container
    }()

    private(set) lazy var viewContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = backgroundContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }()

    private(set) lazy var backgroundContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        return context
    }()

    private init() {
        initPipelines()
    }

    func saveChanges() {
        backgroundContext.performAndWait {
            if backgroundContext.hasChanges {
                do {
                    try backgroundContext.save()
                } catch let error {
                    backgroundContext.rollback()
                    // TODO: - поменять debugPrint на логи
#if DEBUG
                    debugPrint("Core data: Error saving \(error)")
#endif
                }
            }
        }
    }
}

private extension CoreDataStack {
    func initPipelines() {
        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { [weak self] _ in
                self?.saveChanges()
            }
            .store(in: &cancellables)
    }
}
