//
//  TasksListPresenter.swift
//  ToDo List
//
//  Created by Глеб Капустин on 14.03.2025.
//

import Foundation

final class TasksListPresenter {

    private var tasksList: [TodoEntity] = []

    weak var view: TasksListViewInput?
    var interactor: TasksListInteractorInput?
    var router: TasksListRouterInput?

    var didSelectCell: ((TodoEntity) -> ())?
    var onCreateButtonTapped: (() -> ())?
    var onEditItem: ((TodoEntity) -> ())?
    var onDeleteItem: ((TodoEntity) -> ())?

    init() {
        setup()
    }
}

extension TasksListPresenter: TasksListViewOutput {

    func setup() {
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

        onCreateButtonTapped = { [weak self] in
            guard let self else { return }
            router?.navigateToDetails(detailsModuleOutput: self, mode: .create, item: nil)
        }

        onEditItem = { [weak self] item in
            guard let self else { return }
            router?.navigateToDetails(detailsModuleOutput: self, mode: .edit, item: item)
        }

        onDeleteItem = { [weak self] item in
            print(item)
        }
    }

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

extension TasksListPresenter: TasksListInteractorOutput {
}

extension TasksListPresenter: TasksDetailsPresenterOutput {

    func createTask(entity: TodoEntity) {
        print(entity)
    }

    func updateTask(entity: TodoEntity) {
        print(entity)
    }

}
