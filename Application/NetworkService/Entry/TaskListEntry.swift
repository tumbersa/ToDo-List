//
//  TaskListEntry.swift
//  ToDo List
//
//  Created by Глеб Капустин on 13.03.2025.
//

import Foundation

struct TaskListEntry: Codable {
    let todos: [TodoEntry]
    let total: Int
    let skip: Int
    let limit: Int
}

struct TodoEntry: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}

