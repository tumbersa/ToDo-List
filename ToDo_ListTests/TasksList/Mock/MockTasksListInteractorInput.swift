//
//  MockTasksListInteractorInput.swift
//  ToDo_ListTests
//
//  Created by Глеб Капустин on 19.03.2025.
//

import Foundation
import XCTest
@testable import ToDo_List

final class MockTasksListInteractorInput: TasksListInteractorInput {
    var tasksList: [TodoEntity] = []
    var fetchTasksListCalled = false
    var updateEntityCalled = false
    var deleteEntityCalled = false
    var addEntityCalled = false

    func fetchTasksList(_ completion: @escaping (Result<[TodoEntity], Error>) -> ()) {
        fetchTasksListCalled = true
        completion(.success(tasksList))
    }

    func update(entity: TodoEntity) {
        updateEntityCalled = true
    }

    func getTasksList() -> [TodoEntity] {
        return tasksList
    }

    func delete(entity: TodoEntity) {
        deleteEntityCalled = true
    }

    func add(entity: TodoEntity) {
        addEntityCalled = true
    }
}

