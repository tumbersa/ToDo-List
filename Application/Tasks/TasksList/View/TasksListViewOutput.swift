//
//  TasksListViewOutput.swift
//  ToDo List
//
//  Created by Глеб Капустин on 14.03.2025.
//

import Foundation

protocol TasksListViewOutput {
    var didSelectCell: ((TodoEntity) -> ())? { get }
    var onCreateButtonTapped: (() -> ())? { get }
    var onEditItem: ((TodoEntity) -> ())? { get }
    var onDeleteItem: ((TodoEntity) -> ())? { get }
    func viewLoaded()
}
