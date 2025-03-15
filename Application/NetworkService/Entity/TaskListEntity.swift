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
            TodoEntity(id: $0.id, title: $0.todo, description: $0.todo, date: Date(), completed: $0.completed)
        }
    }
}

struct TodoEntity: Hashable {
    let id: Int
    let title: String
    let description: String
    let date: Date
    let completed: Bool

    init(id: Int, title: String, description: String, date: Date, completed: Bool) {
        self.id = id
        self.title = title
        self.description = description
        self.date = date
        self.completed = completed
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

