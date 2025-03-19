//
//  TasksDetailsPresenterOutput.swift
//  ToDo List
//
//  Created by Глеб Капустин on 19.03.2025.
//

import Foundation

protocol TasksDetailsPresenterOutput: AnyObject {
    func updateTask(entity: TodoEntity)
    func createTask(entity: TodoEntity)
}
