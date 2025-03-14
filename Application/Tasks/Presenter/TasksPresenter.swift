//
//  TasksPresenter.swift
//  ToDo List
//
//  Created by Глеб Капустин on 14.03.2025.
//

import Foundation

final class TasksPresenter {
    weak var view: TasksListViewInput?
    var interactor: TasksInteractorInput?
    var router: TasksRouterInput?

    private enum Constants {
        static let firstSetup = "FirstSetup"
    }

    private var tasksList: [TodoEntity] = []
}

extension TasksPresenter: TasksInteractorOutput {
    func viewLoaded() {
//        if !UserDefaults.standard.bool(forKey: Constants.firstSetup) {
//            UserDefaults.standard.set(true, forKey: Constants.firstSetup)
            interactor?.fetchTasksList{ result in
                switch result {
                    case let .success(entity):
                        self.tasksList = entity.todos
                    case let .failure(error):
                        debugPrint(error)
                }
            }
       // }
    }
}
