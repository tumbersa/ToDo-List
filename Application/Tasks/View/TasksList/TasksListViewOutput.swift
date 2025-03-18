//
//  TasksListViewOutput.swift
//  ToDo List
//
//  Created by Глеб Капустин on 14.03.2025.
//

import Foundation

protocol TasksListViewOutput {
    var didSelectCell: ((TodoEntity) -> ())? { get }
}
