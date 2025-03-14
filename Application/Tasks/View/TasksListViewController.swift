//
//  TasksListViewController.swift
//  ToDo List
//
//  Created by Глеб Капустин on 13.03.2025.
//

import UIKit

final class TasksListViewController: UIViewController {

    var output: TasksInteractorOutput?

    override func viewDidLoad() {
        super.viewDidLoad()

        output?.viewLoaded()
    }

}

extension TasksListViewController: TasksListViewInput {
    
}
