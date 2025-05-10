//
//  TasksListInteractorInput.swift
//  ToDo List
//
//  Created by Глеб Капустин on 14.03.2025.
//

import Foundation

protocol TasksListInteractorInput {
    func getTasksList() async -> [TodoEntity]
    func fetchTasksList(_ completion: @escaping (Result<[TodoEntity], Error>) -> ()) async
    func update(entity: TodoEntity) async
    func delete(entity: TodoEntity) async
    func add(entity: TodoEntity) async
}
