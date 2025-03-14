//
//  TasksInteractor.swift
//  ToDo List
//
//  Created by Глеб Капустин on 14.03.2025.
//

import Foundation

final class TasksInteractor: TasksInteractorInput {
    private let networkService: INetworkService

    weak var output: TasksInteractorOutput?

    init(networkService: INetworkService) {
        self.networkService = networkService
    }

    func fetchTasksList(_ completion: @escaping (Result<TaskListEntity, Error>) -> ()) {
        networkService.obtainTasksListResult { result in
            DispatchQueue.main.async {
                switch result {
                    case let .success(entity):
                        completion(.success(entity))
                    case let .failure(error):
                        completion(.failure(error))
                }
            }
        }
    }
}
