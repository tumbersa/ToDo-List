//
//  MockTasksListViewInput.swift
//  ToDo_ListTests
//
//  Created by Глеб Капустин on 19.03.2025.
//

import Foundation
import XCTest
@testable import ToDo_List

final class MockTasksListViewInput: TasksListViewInput {
    var setupInitialStateCalled = false
    var updateItemsCalled = false
    var updatedItems: [TodoEntity] = []

    func setupInitialState(_ tasksList: [TodoEntity]) {
        setupInitialStateCalled = true
        updatedItems = tasksList
    }

    func updateItems(_ tasksList: [TodoEntity]) {
        updateItemsCalled = true
        updatedItems = tasksList
    }
}
