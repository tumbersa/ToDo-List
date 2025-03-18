//
//  TasksListRouter.swift
//  ToDo List
//
//  Created by Глеб Капустин on 14.03.2025.
//

import Foundation
import UIKit

final class TasksListRouter: TasksListRouterInput {
    weak var view: UINavigationController?

    func navigateToDetails() {
        let detailsViewController = TasksDetailsModuleBuilder.build()
        view?.pushViewController(detailsViewController, animated: true)
    }
}
