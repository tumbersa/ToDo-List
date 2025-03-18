//
//  TasksDetailsPresenter.swift
//  ToDo List
//
//  Created by Глеб Капустин on 19.03.2025.
//

import Foundation

final class TasksDetailsPresenter {

    weak var view: TasksDetailsViewInput?
    var interactor: TasksDetailsInteractorInput?
    var router: TasksDetailsRouterInput?

}

extension TasksDetailsPresenter: TasksDetailsInteractorOutput {}

extension TasksDetailsPresenter: TasksDetailsViewOutput {}
