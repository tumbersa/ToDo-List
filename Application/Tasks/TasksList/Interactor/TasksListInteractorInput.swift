//
//  TasksListInteractorInput.swift
//  ToDo List
//
//  Created by Глеб Капустин on 14.03.2025.
//

import Foundation

protocol TasksListInteractorInput {
    func getTasksList() -> [TodoEntity]
    func fetchTasksList(_ completion: @escaping (Result<[TodoEntity], Error>) -> ())
    func update(entity: TodoEntity)
}
