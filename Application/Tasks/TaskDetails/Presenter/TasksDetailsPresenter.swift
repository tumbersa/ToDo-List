//
//  TasksDetailsPresenter.swift
//  ToDo List
//
//  Created by Глеб Капустин on 19.03.2025.
//

import Foundation

final class TasksDetailsPresenter: TasksDetailsPresenterInput {

    private let mode: TasksDetailsModuleMode
    private let entity: TodoEntity?

    weak var output: TasksDetailsPresenterOutput?
    var onUpdateTask: ((TodoEntity) -> ())?
    var viewWillDisappear: ((TodoEntity) -> ())?

    weak var view: TasksDetailsViewInput?
    var interactor: TasksDetailsInteractorInput?
    var router: TasksDetailsRouterInput?

    init(mode: TasksDetailsModuleMode, entity: TodoEntity?) {
        self.mode = mode
        self.entity = entity

    }
}

extension TasksDetailsPresenter: TasksDetailsInteractorOutput {}

extension TasksDetailsPresenter: TasksDetailsViewOutput {

    func viewLoaded() {
        if let entity {
            view?.setupInitialState(entity)
        }

        viewWillDisappear = {[weak self] entity in
            guard let self else { return }
            switch mode {
                case .create:
                    output?.createTask(entity: entity)
                case .edit:
                    output?.updateTask(entity: entity)
            }
        }
    }

}
