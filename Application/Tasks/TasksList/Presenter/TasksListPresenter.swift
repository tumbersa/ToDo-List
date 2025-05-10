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

            let newEntity = TodoEntity(
                id: entity.id,
                title: entity.title,
                description: entity.description,
                date: entity.date,
                completed: !entity.completed
            )

            Task { [weak self] in
                guard let self = self else { return }

                await self.interactor?.update(entity: newEntity)
                let updatedItems = await self.interactor?.getTasksList()

                Task { @MainActor [weak self] in
                    guard let self = self else { return }
                    self.view?.updateItems(updatedItems ?? [])
                }
            }
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
            Task { [weak self] in
                await self?.interactor?.delete(entity: item)
                let newItems = await self?.interactor?.getTasksList()
                Task { @MainActor [weak self] in
                    self?.view?.updateItems(newItems ?? [])
                }
            }
        }
    }

    func viewLoaded() {
        Task {
            await interactor?.fetchTasksList{ [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(entity):
                    tasksList = entity
                    view?.setupInitialState(tasksList)
                case let .failure(error):
                    UserDefaults.standard.set(false, forKey: Constants.firstSetup)
#if DEBUG
                    debugPrint(error)
#endif
                }
            }
        }
    }

}

extension TasksListPresenter: TasksListInteractorOutput {
}

extension TasksListPresenter: TasksDetailsPresenterOutput {

    func createTask(entity: TodoEntity) {
        Task {
            await interactor?.add(entity: entity)
            let newItems = await interactor?.getTasksList()
            Task { @MainActor in
                view?.updateItems(newItems ?? [])
            }
        }

    }

    func updateTask(entity: TodoEntity) {
        Task {
            await interactor?.update(entity: entity)
            let updatedItems = await self.interactor?.getTasksList()

            Task { @MainActor in
                self.view?.updateItems(updatedItems ?? [])
            }
        }
    }

}
