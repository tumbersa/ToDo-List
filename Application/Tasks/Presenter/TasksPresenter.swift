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
            interactor?.fetchTasksList{[weak self] result in
                guard let self else { return }
                switch result {
                    case let .success(entity):
                        tasksList = entity.todos
                        view?.setupInitialState(tasksList)
                    case let .failure(error):
                        debugPrint(error)
                }
            }
       // }
    }
}
