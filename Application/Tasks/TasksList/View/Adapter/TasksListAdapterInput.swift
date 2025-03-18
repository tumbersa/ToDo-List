//
//  TasksListAdapterInput.swift
//  ToDo List
//
//  Created by Глеб Капустин on 14.03.2025.
//

import Foundation

protocol TasksListAdapterInput {
    func configure(with items: [TodoEntity])
    func update(items: [TodoEntity])
}
