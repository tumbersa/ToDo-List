//
//  TasksListRouter.swift
//  ToDo List
//
//  Created by Глеб Капустин on 14.03.2025.
//

import Foundation
import UIKit

final class TasksListRouter: TasksListRouterInput  {

    weak var view: UINavigationController?

    func navigateToDetails(detailsModuleOutput: TasksDetailsPresenterOutput, mode: TasksDetailsModuleMode, item: TodoEntity?) {
        var (detailsViewController, detailsPresenter) = TasksDetailsModuleBuilder.build(mode: mode, entity: item)
        detailsPresenter.output = detailsModuleOutput
        view?.pushViewController(detailsViewController, animated: true)
    }
}
