//
//  TasksListViewInput.swift
//  ToDo List
//
//  Created by Глеб Капустин on 14.03.2025.
//

import Foundation

protocol TasksListViewInput: AnyObject {
    func setupInitialState(_ tasksList: [TodoEntity])
    func updateItems(_ tasksList: [TodoEntity])
}
