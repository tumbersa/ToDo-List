//
//  TasksListAdapterOutput.swift
//  ToDo List
//
//  Created by Глеб Капустин on 14.03.2025.
//

import Foundation

protocol TasksListAdapterOutput: AnyObject {
    var didSelectCell: ((TodoEntity) -> ())? { get }
    var onEditItem: ((TodoEntity) -> ())? { get }
    var onShareItem: ((TodoEntity) -> ())? { get }
    var onDeleteItem: ((TodoEntity) -> ())? { get }
}
