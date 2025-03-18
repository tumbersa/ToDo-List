//
//  TasksDetailsInteractor.swift
//  ToDo List
//
//  Created by Глеб Капустин on 19.03.2025.
//

import Foundation

final class TasksDetailsInteractor<Store: IStore> where Store.Entity == TodoEntity {

    private let todoStore: Store

    weak var output: TasksDetailsInteractorOutput?

    init(todoStore: Store) {
        self.todoStore = todoStore
    }

}

extension TasksDetailsInteractor: TasksDetailsInteractorInput {

}
