//
//  TasksInteractorInput.swift
//  ToDo List
//
//  Created by Глеб Капустин on 14.03.2025.
//

import Foundation

protocol TasksInteractorInput {
    func fetchTasksList(_ completion: @escaping (Result<TaskListEntity, Error>) -> ())
}
