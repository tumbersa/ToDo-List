//
//  TasksDetailsModuleBuilder.swift
//  ToDo List
//
//  Created by Глеб Капустин on 19.03.2025.
//

import Foundation
import UIKit

enum TasksDetailsModuleMode {
    case create
    case edit
}

enum TasksDetailsModuleBuilder {
    static func build(mode: TasksDetailsModuleMode, entity: TodoEntity?) -> (UIViewController, TasksDetailsPresenterInput)  {
        let viewController = TasksDetailsViewController()
        let interactor = TasksDetailsInteractor()
        let presenter = TasksDetailsPresenter(mode: mode, entity: entity)
        let router = TasksDetailsRouter()

        viewController.output = presenter
        presenter.view = viewController
        presenter.router = router
        router.view = viewController
        presenter.interactor = interactor
        interactor.output = presenter

        return (viewController, presenter)
    }
}
