//
//  TasksDetailsViewController.swift
//  ToDo List
//
//  Created by Глеб Капустин on 19.03.2025.
//

import UIKit

final class TasksDetailsViewController: UIViewController {

    var output: TasksDetailsViewOutput?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .label
    }
}

extension TasksDetailsViewController: TasksDetailsViewInput {}
