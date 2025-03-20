//
//  MockTasksListRouterInput.swift
//  ToDo_ListTests
//
//  Created by Глеб Капустин on 19.03.2025.
//

import Foundation
import XCTest
@testable import ToDo_List

final class MockTasksListRouterInput: TasksListRouterInput {
    var navigateToDetailsCalled = false

    func navigateToDetails(detailsModuleOutput: TasksDetailsPresenterOutput, mode: TasksDetailsModuleMode, item: TodoEntity?) {
        navigateToDetailsCalled = true
    }
}
