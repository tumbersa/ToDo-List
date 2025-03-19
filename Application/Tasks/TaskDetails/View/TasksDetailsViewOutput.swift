//
//  TasksDetailsViewOutput.swift
//  ToDo List
//
//  Created by Глеб Капустин on 19.03.2025.
//

import Foundation

protocol TasksDetailsViewOutput {
    func viewLoaded()
    var viewWillDisappear: ((TodoEntity) -> ())? { get }
}
