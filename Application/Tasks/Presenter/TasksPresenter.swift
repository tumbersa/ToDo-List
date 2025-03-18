//
//  TasksPresenter.swift
//  ToDo List
//
//  Created by Глеб Капустин on 14.03.2025.
//

import Foundation

final class TasksPresenter {

    private var tasksList: [TodoEntity] = []

    weak var view: TasksListViewInput?
    var interactor: TasksInteractorInput?
    var router: TasksRouterInput?
    var didSelectCell: ((TodoEntity) -> ())?

    init() {
        didSelectCell = { [weak self] entity in
            guard let self else { return }
            let newEntity: TodoEntity = .init(
                id: entity.id,
                title: entity.title,
                description: entity.description,
                date: entity.date,
                completed: !entity.completed
            )

            interactor?.update(entity: newEntity)
            let updatedItems = interactor?.getTasksList()
            view?.updateItems(updatedItems ?? [])
        }
    }
}

extension TasksPresenter: TasksInteractorOutput {
    func viewLoaded() {
        interactor?.fetchTasksList{[weak self] result in
            guard let self else { return }
            switch result {
                case let .success(entity):
                    tasksList = entity
                    view?.setupInitialState(tasksList)
                case let .failure(error):
                    debugPrint(error)
            }
        }
    }
}
