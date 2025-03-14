//
//  TaskListEntity.swift
//  ToDo List
//
//  Created by Глеб Капустин on 13.03.2025.
//

import Foundation

struct TaskListEntity {
    let todos: [TodoEntity]

    init(todos: [TodoEntity]) {
        self.todos = todos
    }

    init(entry: TaskListEntry) {
        self.todos = entry.todos.map {
            TodoEntity(id: $0.id, title: $0.todo, completed: $0.completed)
        }
    }
}

struct TodoEntity {
    let id: Int
    let title: String
    let description: String?
    let date: Date?
    let completed: Bool

    init(id: Int, title: String, description: String? = nil, date: Date? = nil, completed: Bool) {
        self.id = id
        self.title = title
        self.description = description
        self.date = date
        self.completed = completed
    }
}

