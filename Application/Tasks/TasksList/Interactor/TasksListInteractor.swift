//
//  TasksListInteractor.swift
//  ToDo List
//
//  Created by Глеб Капустин on 14.03.2025.
//

import Foundation

final class TasksListInteractor {

    private let networkService: INetworkService
    private let todoStore: CoreDataStorage

    weak var output: TasksListInteractorOutput?

    init(networkService: INetworkService, todoStore: CoreDataStorage) {
        self.networkService = networkService
        self.todoStore = todoStore
    }

}

extension TasksListInteractor: TasksListInteractorInput {

    func fetchTasksList(_ completion: @escaping (Result<[TodoEntity], Error>) -> ()) async {
        let result: Result<[TodoEntity], Error> = await withCheckedContinuation { continuation in
            if !UserDefaults.standard.bool(forKey: Constants.firstSetup) {
                UserDefaults.standard.set(true, forKey: Constants.firstSetup)
                networkService.obtainTasksListResult { [weak self] result in
                    guard let self else {
                        continuation.resume(returning: .failure(NSError(domain: "InteractorDeallocated", code: 0)))
                        return
                    }
                    Task {
                        switch result {
                        case let .success(entity):
                            for todoEntity in entity.todos {
                                await self.add(entity: todoEntity)
                            }
                            let todos = await self.todoStore.todoEntities
                            continuation.resume(returning: .success(todos))
                        case let .failure(error):
                            continuation.resume(returning: .failure(error))
                        }
                    }
                }
            } else {
                Task {
                    let todos = await self.todoStore.todoEntities
                    continuation.resume(returning: .success(todos))
                }
            }
        }

        Task { @MainActor in
            completion(result)
        }
    }

    func update(entity: TodoEntity) async {
        await todoStore.update(entity: entity)
    }

    func getTasksList() async -> [TodoEntity] {
        await todoStore.todoEntities
    }

    func delete(entity: TodoEntity) async {
        await todoStore.delete(entity: entity)
    }

    func add(entity: TodoEntity) async {
        await todoStore.add(entity: entity)
    }
}
