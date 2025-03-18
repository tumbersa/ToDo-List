//
//  TasksDetailsModuleBuilder.swift
//  ToDo List
//
//  Created by Глеб Капустин on 19.03.2025.
//

import Foundation
import UIKit

enum TasksDetailsModuleBuilder {
    static func build() -> UIViewController {
        let viewController = TasksDetailsViewController()
        let interactor = TasksDetailsInteractor(todoStore: TodoStore.shared)
        let presenter = TasksDetailsPresenter()
        let router = TasksDetailsRouter()

        viewController.output = presenter
        presenter.view = viewController
        presenter.router = router
        router.view = viewController
        presenter.interactor = interactor
        interactor.output = presenter

        return viewController
    }
}
