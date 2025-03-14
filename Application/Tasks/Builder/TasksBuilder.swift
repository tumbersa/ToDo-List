//
//  TasksBuilder.swift
//  ToDo List
//
//  Created by Глеб Капустин on 14.03.2025.
//

import Foundation
import UIKit

enum TasksBuilder {
    static func build() -> UIViewController {
        let viewController = TasksListViewController()
        let interactor = TasksInteractor(networkService: NetworkService())
        let prenter = TasksPresenter()
        let router = TasksRouter()
        let navigationViewController = UINavigationController(rootViewController: viewController)

        viewController.output = prenter
        prenter.view = viewController
        prenter.router = router
        router.view = navigationViewController
        prenter.interactor = interactor
        interactor.output = prenter

        return navigationViewController
    }
}
