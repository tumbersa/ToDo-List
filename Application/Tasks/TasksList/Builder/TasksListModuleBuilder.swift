//
//  TasksListModuleBuilder.swift
//  ToDo List
//
//  Created by Глеб Капустин on 14.03.2025.
//

import Foundation
import UIKit

enum TasksListModuleBuilder {
    static func build() -> UIViewController {
        let viewController = TasksListViewController()
        let interactor = TasksListInteractor(networkService: NetworkService(), todoStore: TodoStore.shared)
        let presenter = TasksListPresenter()
        let router = TasksListRouter()
        let navigationViewController = UINavigationController(rootViewController: viewController)

        viewController.output = presenter
        presenter.view = viewController
        presenter.router = router
        router.view = navigationViewController
        presenter.interactor = interactor
        interactor.output = presenter

        return navigationViewController
    }
}
