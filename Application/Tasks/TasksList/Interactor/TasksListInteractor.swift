//
//  TasksListInteractor.swift
//  ToDo List
//
//  Created by Глеб Капустин on 14.03.2025.
//

import Foundation

final class TasksListInteractor<Store: IStore> where Store.Entity == TodoEntity {

    private let networkService: INetworkService
    private let todoStore: Store

    weak var output: TasksListInteractorOutput?

    init(networkService: INetworkService, todoStore: Store) {
        self.networkService = networkService
        self.todoStore = todoStore
    }

}

extension TasksListInteractor: TasksListInteractorInput {

    func fetchTasksList(_ completion: @escaping (Result<[TodoEntity], Error>) -> ()) {
        if !UserDefaults.standard.bool(forKey: Constants.firstSetup) {
            UserDefaults.standard.set(true, forKey: Constants.firstSetup)
            networkService.obtainTasksListResult { [weak self] result in
                guard let self else { return }
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    switch result {
                        case let .success(entity):
                            for todoEntity in entity.todos {
                                todoStore.addEntity(todoEntity)
                            }
                            completion(.success(todoStore.entities))
                        case let .failure(error):
                            completion(.failure(error))
                    }
                }
            }
        } else {
            completion(.success(todoStore.entities))
        }
    }

    func update(entity: TodoEntity) {
        todoStore.updateEntity(entity)
    }

    func getTasksList() -> [TodoEntity] {
        todoStore.entities
    }

}
